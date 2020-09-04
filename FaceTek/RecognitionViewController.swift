//
//  RecognitionViewController.swift
//  LiveRecognition
//
//  Created by Anton on 07/03/2019.
//  Copyright © 2019 Luxand, Inc. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import GLKit
import OpenGLES.ES2


class RecognitionViewController: UIViewController, RecognitionCameraDelegate, UIAlertViewDelegate {
	struct DetectFaceParams {
		var buffer: UnsafeMutablePointer<UInt8>
		var width: Int32
		var height: Int32
		var scanline: Int32
		var ratio: Float32
	}
	
	struct FaceRectangle {
		var x1: Int32
		var x2: Int32
		var y1: Int32
		var y2: Int32
	}
	
	var customView = UIView()
	var customSubView = UIView()
	
	let MAX_FACES = 5
	let MAX_NAME_LEN = 1024
	let ATTRIB_VERTEX = 0
	let ATTRIB_TEXTUREPOSITON = 1
	let NUM_ATTRIBUTES = 2
	let HELP_TEXT = "Just tap any detected face and name it. The app will recognize this face further. For best results, hold the device at arm's length. You may slowly rotate the head for the app to memorize you at multiple views. The app can memorize several persons. If a face is not recognized, tap and name it again. The SDK is available for mobile developers: www.luxand.com/facesdk"
	
	var glView: RecognitionGLView?
	var camera: RecognitionCamera?
	var screenForDisplay: UIScreen?
	var directDisplayProgram: GLuint = 0
	var videoFrameTexture: GLuint = 0
	var rawPositionPixels: GLubyte = 0
	var rotating: Bool = false
	var videoStarted: Bool = false
	var processingImage: Bool = false
	var toolbar: UIToolbar?
	var oldOrientation: UIInterfaceOrientation = UIInterfaceOrientation.unknown
	
	// face processing
	var closing: Bool = false
	var enteredNameLock: NSLock = NSLock()
	var enteredName: String = String()
	var enteredNameChanged: Bool = false
	var namedFaceID: Int64 = -1
	var trackingRects = [CALayer]()
	var nameLabels = [CATextLayer]()
	var faceDataLock: NSLock = NSLock()
	var faces = [FaceRectangle]()
	var nameDataLock: NSLock = NSLock()
	var names = NSMutableArray()
	var IDs = [Int64]()
	var faceTouchedLock: NSLock = NSLock()
	var faceTouched: Bool = false
	var indexOfTouchedFace: Int = -1
	var idOfTouchedFace: Int64 = -1
	var currentTouchPoint: CGPoint = CGPoint()
	var clearTracker: Bool = false
	var clearTrackerLock: NSLock = NSLock()
	var tracker: HTracker = 0
	var templatePath: String = String()
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	init(screen: UIScreen) {
		super.init(nibName: nil, bundle: nil)
		
		screenForDisplay = screen
		rotating = false
		processingImage = false
		trackingRects.removeAll()
		nameLabels.removeAll()
		faces.removeAll()
		names.removeAllObjects()
		IDs.removeAll()
		for _ in 1...MAX_FACES {
			trackingRects.append(CALayer())
			nameLabels.append(CATextLayer())
			faces.append(FaceRectangle(x1: 0, x2: 0, y1: 0, y2: 0))
			names.add(String())
			IDs.append(-1)
		}
		
		// Load tracker memory
		let homeDir = NSHomeDirectory()
		let filePath = "Documents/Memory70.dat"
		if (homeDir.last == "/") {
			templatePath = "\(homeDir)\(filePath)"
		} else {
			templatePath = "\(homeDir)/\(filePath)"
		}
		if (FSDKE_OK != FSDK_LoadTrackerMemoryFromFile(&tracker, (templatePath as NSString).utf8String)) {
			FSDK_CreateTracker(&tracker)
		}
		resetTrackerParameters()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		UIApplication.shared.isIdleTimerDisabled = true
	}
	
	@objc
	func clearAction(sender: UIBarButtonItem) {
		let alert = UIAlertView(title: "", message: "Are you sure to clear the memory?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Ok")
		alert.tag = 0xC
		alert.show()
	}
	
	@objc
	func helpAction(sender: UIBarButtonItem) {
		let alert = UIAlertView(title: "Luxand Face Recognition", message: HELP_TEXT, delegate: nil, cancelButtonTitle: "Ok")
		alert.show()
	}
	
	func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
		if (alertView.tag == 0xC) { // Clear memory
			if (buttonIndex == 1) {
				clearTrackerLock.lock()
				clearTracker = true
				clearTrackerLock.unlock()
			}
		} else if (alertView.tag == 0xF) { // enter name for the Face
			faceTouchedLock.lock()
			if (buttonIndex == 0 || idOfTouchedFace == -1) {
				faceTouched = false
				faceTouchedLock.unlock()
				return
			}
			
			let name = alertView.textField(at: 0)?.text
			let truncName = String(name!.prefix(MAX_NAME_LEN))
			
			enteredNameLock.lock()
			namedFaceID = idOfTouchedFace
			enteredName = truncName
			enteredNameChanged = true
			
			// immediately display the name
			let i = Int(indexOfTouchedFace)
			if (i >= 0) {
				nameDataLock.lock()
				names.replaceObject(at: i, with: truncName)
				nameDataLock.unlock()
			}
			
			
			faceTouched = false
			enteredNameLock.unlock()
			faceTouchedLock.unlock()
			
		}
	}
	
	
	// touch handling
	
	func pointInRectangle(point_x: Int32, point_y: Int32, rect_x1: Int32, rect_y1: Int32, rect_x2: Int32, rect_y2: Int32) -> Bool {
		return (point_x >= rect_x1) && (point_x <= rect_x2) && (point_y >= rect_y1) && (point_y <= rect_y2)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		currentTouchPoint = touches.first!.location(in: self.view)
		let x = Int32(currentTouchPoint.x)
		let y = Int32(currentTouchPoint.y)
		
		faceTouchedLock.lock()
		idOfTouchedFace = -1
		
		faceDataLock.lock()
		for i in 0...MAX_FACES-1 {
			if (pointInRectangle(point_x: x, point_y: y, rect_x1: faces[i].x1, rect_y1: faces[i].y1, rect_x2: faces[i].x2, rect_y2: faces[i].y2+30)) {
				indexOfTouchedFace = i
				idOfTouchedFace = IDs[i]
				break
			}
		}
		faceDataLock.unlock()
		
		if (idOfTouchedFace >= 0) {
			storedFaceID()
			DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
				self.faceTouched = true
				self.updatedetails()
			}
			
			//            let alert = UIAlertView(title: "", message: "Enter person's name", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Ok")
			//            alert.alertViewStyle = UIAlertViewStyle.plainTextInput
			//            alert.tag = 0xF
			//            alert.show()
		}
		
		faceTouchedLock.unlock()
	}
	
	func storedFaceID() {
		let namestr = UserDefaults.standard.integer(forKey: "empId").description
		let truncName = String(namestr.prefix(MAX_NAME_LEN))
		enteredNameLock.lock()
		namedFaceID = idOfTouchedFace
		enteredName = truncName
		enteredNameChanged = true
		// immediately display the name
		let i = Int(indexOfTouchedFace)
		if (i >= 0) {
			nameDataLock.lock()
			names.replaceObject(at: i, with: truncName)
			nameDataLock.unlock()
		}
		enteredNameLock.unlock()
	}
	
	// device rotation support
	
	override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
		rotating = true
		for i in 0...MAX_FACES-1 {
			trackingRects[i].isHidden = true
		}
		toolbar?.isHidden = true
		glView?.isHidden = true
	}
	
	override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
		for i in 0...MAX_FACES-1 {
			trackingRects[i].isHidden = false
		}
		rotating = false
	}
	
	override func loadView() {
		// Calling Camera permission Method
		checkCameraAccess()
		
		let mainScreenFrame: CGRect? = UIScreen.main.bounds
		let primaryView: UIView = UIView(frame: mainScreenFrame!)
		view = primaryView
		
		glView = RecognitionGLView(frame: mainScreenFrame!)
		//glView should be re-initialized in (void)drawFrame with proper size
		
		view.addSubview(glView!)
		
		// Set up the toolbar at the bottom of the screen
		//        toolbar = UIToolbar()
		//        toolbar?.barStyle = UIBarStyle.blackTranslucent;
		//        let clearItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.trash, target: self, action: #selector(clearAction))
		//        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
		//        let helpItem = UIBarButtonItem(title: "?", style: UIBarButtonItemStyle.plain, target: self, action: #selector(helpAction))
		//        toolbar?.items = [clearItem, flexibleSpace, helpItem]
		//        toolbar?.sizeToFit()
		//        let toolbarHeight = toolbar?.frame.size.height
		//        let mainViewBounds = view.bounds
		//        toolbar?.frame = CGRect(x: mainViewBounds.minX, y: mainViewBounds.minY + mainViewBounds.height - toolbarHeight!, width: mainViewBounds.width, height: toolbarHeight!)
		//        view.addSubview(toolbar!)
		
		
		if (loadShaders(vertexShaderName: "DirectDisplayShader", fragmentShaderName: "DirectDisplayShader", programPointer: &directDisplayProgram)) {
			print("Shaders loaded")
		} else {
			print("Error loading shaders.")
			exit(1)
		}
		
		for i in 0...MAX_FACES-1 {
			trackingRects[i].bounds = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
			trackingRects[i].cornerRadius = 0.0
			trackingRects[i].borderColor = UIColor.blue.cgColor
			trackingRects[i].borderWidth = 2.0
			trackingRects[i].position = CGPoint(x: 100, y: 100)
			trackingRects[i].opacity = 0.0
			trackingRects[i].anchorPoint = CGPoint(x: 0, y: 0) //for position to be the top-left corner
			nameLabels[i].fontSize = 20
			nameLabels[i].frame = CGRect(x: 10.0, y: 10.0, width: 200.0, height: 40.0)
			nameLabels[i].string = "Click here to register"
			nameLabels[i].foregroundColor = UIColor.green.cgColor
			nameLabels[i].alignmentMode = kCAAlignmentCenter
			trackingRects[i].addSublayer(nameLabels[i])
			
			// Disable animations for move and resize (otherwise trackingRect will jump)
			trackingRects[i].actions = ["sublayer":NSNull(),"position":NSNull(),"bounds":NSNull()]
			nameLabels[i].actions = ["sublayer":NSNull(),"position":NSNull(),"bounds":NSNull()]
		}
		
		for i in 0...MAX_FACES-1 {
			glView?.layer.actions = ["sublayer":NSNull()]
			glView?.layer.addSublayer(trackingRects[i])
		}
		
		camera = RecognitionCamera(position: AVCaptureDevice.Position.front);
		camera?.delegate = self
	}
	
	func screenSizeOrientationIndependent() -> CGSize {
		let screenSize = UIScreen.main.bounds.size
		return CGSize(width: min(screenSize.width, screenSize.height), height: max(screenSize.width, screenSize.height))
	}
	
	func relocateSubviewsForOrientation(orientation: UIInterfaceOrientation) {
		glView?.destroyFramebuffer()
		glView?.removeFromSuperview()
		
		let applicationFrame = screenSizeOrientationIndependent()
		
		let video_width = camera?.width
		let video_height = camera?.height
		if (orientation == UIInterfaceOrientation.unknown || orientation == UIInterfaceOrientation.portrait || orientation == UIInterfaceOrientation.portraitUpsideDown) {
			let height = Double(applicationFrame.width) * (Double(video_width!) * 1.0 / Double(video_height!))
			glView = RecognitionGLView(frame: CGRect(x: 0.0, y: 0.0, width: Double(applicationFrame.width), height: height))
		} else {
			let width = Double(applicationFrame.width) * (Double(video_width!) * 1.0 / Double(video_height!))
			glView = RecognitionGLView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: Double(applicationFrame.width)))
		}
		glView?.center = view.center
		view.addSubview(glView!)
		
		if (loadShaders(vertexShaderName: "DirectDisplayShader", fragmentShaderName: "DirectDisplayShader", programPointer: &directDisplayProgram)) {
			print("Shaders loaded")
		} else {
			print("Error loading shaders.")
			exit(1)
		}
		
		for i in 0...MAX_FACES-1 {
			glView?.layer.actions = ["sublayer":NSNull()]
			glView?.layer.addSublayer(trackingRects[i])
		}
		
		// Toolbar re-alignment
		//        let toolbarHeight = toolbar?.frame.size.height
		//        let mainViewBounds = view.bounds
		//        toolbar?.frame = CGRect(x: mainViewBounds.minX, y: mainViewBounds.minY + mainViewBounds.height - toolbarHeight!, width: mainViewBounds.width, height: toolbarHeight!)
		//        view.addSubview(toolbar!)
		//        toolbar?.isHidden = false
		
		view.sendSubview(toBack: glView!)
	}
	
	func processNewCameraFrame(cameraFrame: CVImageBuffer) {
		if (rotating) {
			return; //not updating GLView on rotating animation (it looks ugly)
		}
		
		CVPixelBufferLockBaseAddress(cameraFrame, CVPixelBufferLockFlags(rawValue: 0))
		let bufferHeight = Int(CVPixelBufferGetHeight(cameraFrame))
		let bufferWidth = Int(CVPixelBufferGetWidth(cameraFrame))
		
		// Create a new texture from the camera frame data, draw it (calling drawFrame)
		glGenTextures(1, &videoFrameTexture)
		glBindTexture(GLenum(GL_TEXTURE_2D), videoFrameTexture)
		glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR)
		glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_LINEAR)
		// This is necessary for non-power-of-two textures
		glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_CLAMP_TO_EDGE)
		glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GL_CLAMP_TO_EDGE)
		
		// Using BGRA extension to pull in video frame data directly
		glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGBA, GLsizei(bufferWidth), GLsizei(bufferHeight), 0, GLenum(GL_BGRA), GLenum(GL_UNSIGNED_BYTE), CVPixelBufferGetBaseAddress(cameraFrame))
		
		drawFrame()
		
		
		faceTouchedLock.lock()
		let faceTouchedVal = faceTouched
		faceTouchedLock.unlock()
		
		if (processingImage == false && !faceTouchedVal) { //TODO - if multiple simultaneous calls of processNewCameraFrame is possible - restore logics with _processingImage arg
			
			if (closing) {
				return
			}
			processingImage = true
			
			// Copy camera frame to buffer
			
			let scanline = CVPixelBufferGetBytesPerRow(cameraFrame)
			let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: scanline * bufferHeight)
			memcpy(buffer, CVPixelBufferGetBaseAddress(cameraFrame), scanline * bufferHeight)
			
			var ratio = Float(0)
			let orientation = UIApplication.shared.statusBarOrientation
			if (orientation == UIInterfaceOrientation.unknown || orientation == UIInterfaceOrientation.portrait || orientation == UIInterfaceOrientation.portraitUpsideDown) {
				ratio = Float(self.view.bounds.size.width) / Float(bufferHeight)
			} else {
				ratio = Float(self.view.bounds.size.height) / Float(bufferHeight)
			}
			
			let args = DetectFaceParams(buffer: buffer, width: Int32(bufferWidth), height: Int32(bufferHeight), scanline: Int32(scanline), ratio: ratio)
			
			DispatchQueue.global(qos: .background).async {
				self.processImage(args: args, orientation: orientation)
			}
		}
		
		glDeleteTextures(1, &videoFrameTexture)
		CVPixelBufferUnlockBaseAddress(cameraFrame, CVPixelBufferLockFlags(rawValue: 0))
	}
	
	func drawFrame() {
		// mirrored square
		/*
		let mirroredSquareVertices: [GLfloat] = [
		1.0, -1.0,
		-1.0, -1.0,
		1.0,  1.0,
		-1.0,  1.0,
		];
		*/
		
		// standard square
		let squareVertices: [GLfloat] = [
			-1.0, -1.0,
			1.0, -1.0,
			-1.0,  1.0,
			1.0,  1.0,
		]
		
		let orientation: UIInterfaceOrientation = UIApplication.shared.statusBarOrientation
		if (orientation != oldOrientation) {
			oldOrientation = orientation
			relocateSubviewsForOrientation(orientation: orientation)
		}
		
		// For some reason that's mandatory for new devices
		glClearColor(0.5, 0.5, 0.5, 1.0);
		glClear(GLenum(GL_COLOR_BUFFER_BIT));
		
		// Rotate the texture (image from camera) accordingly to current orientation
		glActiveTexture(GLenum(GL_TEXTURE0))
		glBindTexture(GLenum(GL_TEXTURE_2D), videoFrameTexture)
		glVertexAttribPointer(GLuint(ATTRIB_VERTEX), 2, GLenum(GL_FLOAT), 0, 0, squareVertices)
		glEnableVertexAttribArray(GLuint(ATTRIB_VERTEX))
		if (orientation == UIInterfaceOrientation.unknown || orientation == UIInterfaceOrientation.portrait) {
			let textureVertices: [GLfloat] = [
				1.0, 0.0,
				1.0, 1.0,
				0.0, 0.0,
				0.0, 1.0,
			]
			glVertexAttribPointer(GLuint(ATTRIB_TEXTUREPOSITON), 2, GLenum(GL_FLOAT), 0, 0, textureVertices)
		} else if(orientation == UIInterfaceOrientation.portraitUpsideDown) {
			let textureVertices: [GLfloat] = [
				0.0, 1.0,
				0.0, 0.0,
				1.0, 1.0,
				1.0, 0.0,
			]
			glVertexAttribPointer(GLuint(ATTRIB_TEXTUREPOSITON), 2, GLenum(GL_FLOAT), 0, 0, textureVertices)
		} else if(orientation == UIInterfaceOrientation.landscapeLeft) {
			let textureVertices: [GLfloat] = [
				1.0, 1.0,
				0.0, 1.0,
				1.0, 0.0,
				0.0, 0.0,
			]
			glVertexAttribPointer(GLuint(ATTRIB_TEXTUREPOSITON), 2, GLenum(GL_FLOAT), 0, 0, textureVertices)
		} else if(orientation == UIInterfaceOrientation.landscapeRight) {
			let textureVertices: [GLfloat] = [
				0.0, 0.0,
				1.0, 0.0,
				0.0, 1.0,
				1.0, 1.0,
			]
			glVertexAttribPointer(GLuint(ATTRIB_TEXTUREPOSITON), 2, GLenum(GL_FLOAT), 0, 0, textureVertices)
		}
		glEnableVertexAttribArray(GLuint(ATTRIB_TEXTUREPOSITON))
		
		
		// Setting bounds and position of trackingRect using data received from FSDK_DetectFace
		// need to disable animations because we can show incorrect (old) name for a moment in result
		
		nameDataLock.lock()
		for i in 0..<MAX_FACES {
			if ((names[i] as! String) != "") {
				nameLabels[i].string = names[i]
				nameLabels[i].foregroundColor = UIColor.blue.cgColor
			} else {
				nameLabels[i].string = "Click here to register"
				nameLabels[i].foregroundColor = UIColor.green.cgColor
			}
		}
		nameDataLock.unlock()
		
		faceDataLock.lock()
		for i in 0..<MAX_FACES {
			if (faces[i].x2 > 0) { // have face
				nameLabels[i].frame = CGRect(x: 10.0, y: Double(faces[i].y2 - faces[i].y1) + 10.0, width: Double(faces[i].x2 - faces[i].x1) - 20.0, height: 40.0)
				trackingRects[i].position = CGPoint(x: Int(faces[i].x1), y: Int(faces[i].y1))
				trackingRects[i].bounds = CGRect(x: 0.0, y: 0.0, width: Double(faces[i].x2 - faces[i].x1), height: Double(faces[i].y2 - faces[i].y1))
				trackingRects[i].opacity = 1.0
			} else { // no face
				trackingRects[i].opacity = 0.0
			}
		}
		faceDataLock.unlock()
		
		glView?.setDisplayFramebuffer()
		glUseProgram(directDisplayProgram)
		glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, 4)
		glView?.presentFramebuffer()
		
		videoStarted = true
	}
	
	func cameraHasConnected() {
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	// OpenGL ES 2.0 init
	func checkGLerror() {
		let err = glGetError()
		print("glGetError \(err)")
	}
	
	func loadShaders(vertexShaderName: String, fragmentShaderName: String, programPointer: inout GLuint) -> Bool {
		var vertexShader: GLuint = 0
		var fragShader: GLuint = 0
		
		//do not supported on iOS
		//glEnable(GL_DEBUG_OUTPUT);
		
		// Create shader program.
		programPointer = glCreateProgram()
		
		// Create and compile vertex shader.
		let vertShaderPathname = Bundle.main.path(forResource: vertexShaderName, ofType: "vsh")
		if (!compileShader(shader: &vertexShader, type: GLenum(GL_VERTEX_SHADER), file: vertShaderPathname!)) {
			print("Failed to compile vertex shader")
			return false
		}
		
		// Create and compile fragment shader.
		let fragShaderPathname = Bundle.main.path(forResource: fragmentShaderName, ofType: "fsh")
		if (!compileShader(shader: &fragShader, type: GLenum(GL_FRAGMENT_SHADER), file: fragShaderPathname!)) {
			print("Failed to compile fragment shader")
			return false
		}
		
		// Attach vertex shader to program.
		glAttachShader(programPointer, vertexShader)
		
		// Attach fragment shader to program.
		glAttachShader(programPointer, fragShader)
		
		// Bind attribute locations.
		// This needs to be done prior to linking.
		glBindAttribLocation(programPointer, GLuint(ATTRIB_VERTEX), "position")
		glBindAttribLocation(programPointer, GLuint(ATTRIB_TEXTUREPOSITON), "inputTextureCoordinate")
		
		// Link program.
		if (!linkProgram(prog: programPointer)) {
			print("Failed to link program: \(programPointer)")
			if (vertexShader != 0) {
				glDeleteShader(vertexShader)
				vertexShader = 0
			}
			if (fragShader != 0) {
				glDeleteShader(fragShader)
				fragShader = 0
			}
			if (programPointer != 0) {
				glDeleteProgram(programPointer)
				programPointer = 0
			}
			return false
		}
		
		// Release vertex and fragment shaders.
		if (vertexShader != 0) {
			glDeleteShader(vertexShader)
			vertexShader = 0
		}
		if (fragShader != 0) {
			glDeleteShader(fragShader)
			fragShader = 0
		}
		return true
	}
	
	func compileShader(shader: inout GLuint, type: GLenum, file: String) -> Bool {
		do {
			shader = glCreateShader(type)
			let source = try String(contentsOfFile: file)
			var cStringSource = (source as NSString).utf8String
			glShaderSource(shader, GLsizei(1), &cStringSource, nil)
			glCompileShader(shader)
			
			/*
			var logLength: GLint = 0
			glGetShaderiv(shader, GLenum(GL_INFO_LOG_LENGTH), &logLength)
			var message = [CChar](repeating: CChar(0), count: Int(logLength+1))
			glGetShaderInfoLog(shader, GLsizei(logLength), &logLength, &message)
			var s = String.init(utf8String: message)!
			print("Shader log: \(s)")
			*/
			
			var status: GLint = 0
			glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &status)
			if (status == 0) {
				glDeleteShader(shader)
				print("Error 2 compiling shader: %@", file)
				return false
			}
		} catch {
			print("Error 1 compiling shader: %@", file)
			return false
		}
		return true
	}
	
	func linkProgram(prog: GLuint) -> Bool {
		glLinkProgram(prog)
		
		/*
		var logLength: GLint = 0
		glGetProgramiv(prog, GLenum(GL_INFO_LOG_LENGTH), &logLength)
		var message = [CChar](repeating: CChar(0), count: Int(logLength+1))
		glGetProgramInfoLog(prog, GLsizei(logLength), &logLength, &message)
		var s = String.init(utf8String: message)!
		print("Program log: \(s)")
		*/
		
		var status: GLint = 0
		glGetProgramiv(prog, GLenum(GL_LINK_STATUS), &status)
		if (status == 0) {
			print("Error linking program")
			return false;
		}
		return true
	}
	
	// Face detection and recognition
	
	func processImage(args: DetectFaceParams, orientation: UIInterfaceOrientation) {
		if (closing) {
			processingImage = false
			return
		}
		
		// Cleaning tracker memory, if the button was pressed
		
		clearTrackerLock.lock()
		if (clearTracker) {
			FSDK_ClearTracker(tracker)
			resetTrackerParameters()
			clearTracker = false
		}
		clearTrackerLock.unlock()
		
		// Reading buffer parameters
		let width: Int32 = args.width
		let height: Int32 = args.height
		let scanline: Int32 = args.scanline
		let ratio: Float32 = args.ratio
		
		
		// Converting BGRA to RGBA
		var p1line = args.buffer
		var p2line = args.buffer + 2
		
		// memory leak if use height-1 and width-1 instead of Int(height-1) and Int(width-1) - mental
		for y in 0...Int(height-1) {
			var p1 = p1line
			var p2 = p2line
			p1line += Int(scanline)
			p2line += Int(scanline)
			for x in 0...Int(width-1) {
				var tmp: UInt8 = p1.pointee
				p1.pointee = p2.pointee
				p2.pointee = tmp
				p1 += 4
				p2 += 4
			}
		}
		
		var image: HImage = 0
		var res = FSDK_LoadImageFromBuffer(&image, args.buffer, width, height, scanline, FSDK_IMAGE_COLOR_32BIT)
		
		args.buffer.deallocate(capacity: Int(args.scanline * args.height))
		
		if (res != FSDKE_OK) {
			print("FSDK_LoadImageFromBuffer failed with \(res)")
			processingImage = false
			return
		}
		
		var derotatedImage: HImage = 0
		res = FSDK_CreateEmptyImage(&derotatedImage)
		if (res != FSDKE_OK) {
			FSDK_FreeImage(image)
			processingImage = false
			return
		}
		
		if (orientation == UIInterfaceOrientation.unknown || orientation == UIInterfaceOrientation.portrait) {
			res = FSDK_RotateImage90(image, 1, derotatedImage)
		} else if (orientation == UIInterfaceOrientation.portraitUpsideDown) {
			res = FSDK_RotateImage90(image, -1, derotatedImage)
		} else if (orientation == UIInterfaceOrientation.landscapeLeft) {
			res = FSDK_RotateImage90(image, 0, derotatedImage)
		} else if (orientation == UIInterfaceOrientation.landscapeRight) {
			res = FSDK_RotateImage90(image, 2, derotatedImage)
		}
		if (res != FSDKE_OK) {
			FSDK_FreeImage(image)
			FSDK_FreeImage(derotatedImage)
			processingImage = false
			return
		}
		
		res = FSDK_MirrorImage_uchar(derotatedImage, 1)
		if (res != FSDKE_OK) {
			FSDK_FreeImage(image)
			FSDK_FreeImage(derotatedImage)
			processingImage = false
			return
		}
		
		
		// Passing entered name to FaceSDK
		enteredNameLock.lock()
		if (enteredNameChanged) {
			if (FSDKE_OK == FSDK_LockID(tracker, namedFaceID)) {
				FSDK_SetName(tracker, namedFaceID, (enteredName as NSString).utf8String)
				if (enteredName == "") {
					FSDK_PurgeID(tracker, namedFaceID)
				}
				FSDK_UnlockID(tracker, namedFaceID)
			}
		}
		enteredName = ""
		enteredNameChanged = false
		enteredNameLock.unlock()
		
		
		// Passing frame to FaceSDK, reading face coordinates and names
		var count: Int64 = 0
		FSDK_FeedFrame(tracker, 0, derotatedImage, &count, &IDs, Int64(IDs.count * Int64.bitWidth/8))
		
		faceDataLock.lock()
		for i in 0..<MAX_FACES {
			faces[i].x1 = 0
			faces[i].x2 = 0
			faces[i].y1 = 0
			faces[i].y2 = 0
		}
		for i in 0..<Int(count) {
			nameDataLock.lock()
			let allNames = UnsafeMutablePointer<Int8>.allocate(capacity: MAX_NAME_LEN+1)
			allNames.initialize(to: 0, count: MAX_NAME_LEN+1)
			FSDK_GetAllNames(tracker, IDs[i], allNames, Int64(MAX_NAME_LEN))
			names.replaceObject(at: i, with: String.init(cString: allNames))
			allNames.deallocate(capacity: MAX_NAME_LEN+1)
			nameDataLock.unlock()
			
			let eyesPtr = UnsafeMutablePointer<FSDK_Features>.allocate(capacity: 1)
			var eyes : FSDK_Features = eyesPtr.pointee
			
			FSDK_GetTrackerEyes(tracker, 0, IDs[i], &eyes)
			
			let face = getFaceFrame(eyes: &eyes)
			
			faces[i].x1 = Int32(Float32(face.x1) * ratio)
			faces[i].x2 = Int32(Float32(face.x2) * ratio)
			faces[i].y1 = Int32(Float32(face.y1) * ratio)
			faces[i].y2 = Int32(Float32(face.y2) * ratio)
			
			eyesPtr.deallocate(capacity: 1)
		}
		faceDataLock.unlock()
		
		
		FSDK_FreeImage(image)
		FSDK_FreeImage(derotatedImage)
		processingImage = false
	}
	
	func getFaceFrame(eyes: inout FSDK_Features) -> FaceRectangle {
		let u1: Double = Double(eyes.0.x)
		let v1: Double = Double(eyes.0.y)
		let u2: Double = Double(eyes.1.x)
		let v2: Double = Double(eyes.1.y)
		let xc: Double = (u1 + u2)/2
		let yc: Double = (v1 + v2)/2
		let w = sqrt((u2 - u1)*(u2 - u1) + (v2 - v1)*(v2 - v1))
		let x1 = Int32(xc - w * 1.6 * 0.9)
		let y1 = Int32(yc - w * 1.1 * 0.9)
		var x2 = Int32(xc + w * 1.6 * 0.9)
		var y2 = Int32(yc + w * 2.1 * 0.9)
		if (x2 - x1 > y2 - y1) {
			x2 = x1 + y2 - y1
		} else {
			y2 = y1 + x2 - x1
		}
		return FaceRectangle(x1: x1, x2: x2, y1: y1, y2: y2)
	}
	
	func resetTrackerParameters() {
		var errpos: Int32 = 0
		FSDK_SetTrackerMultipleParameters(tracker, ("ContinuousVideoFeed=true;FacialFeatureJitterSuppression=0;RecognitionPrecision=1;Threshold=0.992;Threshold2=0.9995;ThresholdFeed=0.97;MemoryLimit=2000;HandleArbitraryRotations=false;DetermineFaceRotationAngle=false;InternalResizeWidth=70;FaceDetectionThreshold=3;" as NSString).utf8String, &errpos)
	}
	
	func updatedetails() {
		
		let defaults = UserDefaults.standard
		let retrivedempId = defaults.integer(forKey: "empId")
		
		let parameters = ["empId": retrivedempId as Any,
						  "empPresistedFaceId": retrivedempId as Any,
						  "empDeviceName": "Oppo" as Any,
						  "empModelNumber": "A7" as Any,
						  "empAndriodVersion": "9" as Any,
						  "employeePic":"base64 converted String" as Any]
		
		let url: NSURL = NSURL(string:"http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/employee/setup/updateEmpAppStatus")!
		
		//now create the URLRequest object using the url object
		var request = URLRequest(url: url as URL)
		request.httpMethod = "POST" //set http method as POST
		
		do {
			request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
		} catch let error {
			print(error.localizedDescription)
		}
		
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		//request.setValue(Verificationtoken, forHTTPHeaderField: "Authentication")
		
		let task = URLSession.shared.dataTask(with: request) { (data, response, error)in
			
			guard let data = data, error == nil else {
				print(error?.localizedDescription ?? "No data")
				return
			}
			
			let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
			if let responseJSON = responseJSON as? [String: Any] {
				print("Json Response",responseJSON)
				
				DispatchQueue.main.async {
					let code = responseJSON["code"] as? NSInteger
					print("face code-----",code as Any)
					if(code == 200) {
						var message = (responseJSON["message"] as? String)!
						print("Successfully inserted ",message)
						
						self.customView.frame = CGRect.init(x: 0, y: 0, width: 310, height: 260)
						self.customView.backgroundColor = UIColor.white     //give color to the view
						self.customView.center = self.view.center
						self.view.addSubview(self.customView)
						self.customSubView.frame = CGRect.init(x: 0, y: 0, width: 311, height: 140)
						//customSubView.backgroundColor = UIColor.yellow     //give color to the view
						self.customSubView.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.537254902, blue: 0.1019607843, alpha: 1)
						let shadowPath = UIBezierPath(rect: self.customView.bounds)
						self.customView.layer.masksToBounds = false
						self.customView.layer.shadowColor = UIColor.darkGray.cgColor
						self.customView.layer.shadowOffset = CGSize(width: 0, height: 0.5)
						self.customView.layer.shadowOpacity = 0.8
						self.customView.layer.shadowPath = shadowPath.cgPath
						self.customView.addSubview(self.customSubView)
						//image
						var imageView : UIImageView
						imageView  = UIImageView(frame:CGRect(x: 100, y: 10, width: 100, height: 100));
						imageView.image = UIImage(named:"conform.png")
						self.customView.addSubview(imageView)
						//lable
						let label = UILabel(frame: CGRect(x: 100, y: 100, width: 200, height: 21))
						//label.center = CGPoint(x: 160, y: 285)
						//label.textAlignment = .center
						label.text = "Thank you!"
						label.font = UIFont(name: "HelveticaNeue", size: CGFloat(22))
						label.font = UIFont.boldSystemFont(ofSize: 22.0)
						label.textColor = UIColor.white
						
						self.customView.addSubview(label)
						let label1 = UILabel(frame: CGRect(x: 30, y: 150, width: 400, height: 21))
						//label.center = CGPoint(x: 160, y: 285)
						//label.textAlignment = .center
						label1.text = "You have successfully registered"
						//label1.textColor = #colorLiteral(red: 0.9098039216, green: 0.537254902, blue: 0.1019607843, alpha: 1)
						label1.textColor = UIColor.darkGray
						label1.shadowColor = UIColor.gray
						label1.font = UIFont(name: "HelveticaNeue", size: CGFloat(16))
						self.customView.addSubview(label1)
						let myButton = UIButton(type: .system)
						// Position Button
						myButton.frame = CGRect(x: 100, y: 180, width: 100, height: 50)
						// Set text on button
						myButton.setTitle("OK", for: .normal)
						myButton.setTitle("Pressed + Hold", for: .highlighted)
						myButton.setTitleColor(UIColor.white, for: .normal)
						myButton.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.537254902, blue: 0.1019607843, alpha: 1)
						// Set button action
						myButton.addTarget(self, action: #selector(self.buttonAction(_:)), for: .touchUpInside)
						self.customView.addSubview(myButton)
					}
				}
			}
		}
		task.resume()
	}
	
	@objc func buttonAction(_ sender:UIButton!) {
		//save tracker file
		saveFile()
		
		//then go to dahsboard
		let count = (self.navigationController?.viewControllers.count)!
		for i:Int in 0...count {
			let vc = self.navigationController?.viewControllers[i]
			if (vc?.isKind(of: ViewController.self))! {
				(vc as! ViewController).showTabBar = true
				self.navigationController?.popToViewController(vc!, animated: true)
				break
			}
		}
	}
	
	private func saveFile() {
		var i = 0
		while (self.processingImage == true) {
			i += 1
			if (i > 20) {
				break
			}
			Thread.sleep(forTimeInterval:0.1)
		}
		
		let fileSaveResult = FSDK_SaveTrackerMemoryToFile(tracker, (templatePath as NSString).utf8String)
		if fileSaveResult == FSDKE_IO_ERROR {
			print("Tracker file has not saved")
		} else if fileSaveResult == FSDKE_OK {
			print("Tracker file has saved successfully")
		}
	}
	
	//Camera Permission code
	func checkCameraAccess() {
		switch AVCaptureDevice.authorizationStatus(for: .video) {
		case .denied:
			print("Denied, request permission from settings")
			presentCameraSettings()
		case .restricted:
			print("Restricted, device owner must approve")
		case .authorized:
			print("Authorized, proceed")
		case .notDetermined:
			AVCaptureDevice.requestAccess(for: .video) { success in
				if success {
					print("Permission granted, proceed")
				} else {
					self.presentCameraSettings()
					print("Permission denied")
				}
			}
		}
	}
	
	func presentCameraSettings() {
		DispatchQueue.main.async {
			
			let alertController = UIAlertController(title: "Error",
													message: "Camera access is denied",
													preferredStyle: .alert)
			alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
			alertController.addAction(UIAlertAction(title: "Settings", style: .cancel) { _ in
				if let url = URL(string: UIApplicationOpenSettingsURLString) {
					UIApplication.shared.open(url, options: [:], completionHandler: { _ in
						// Handle
					})
				}
			})
			
			self.present(alertController, animated: true)
		}
	}
	
}
