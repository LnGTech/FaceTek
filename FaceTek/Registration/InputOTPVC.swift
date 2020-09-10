//
//  InputOTPVC.swift
//  OTPDemo
//
//  Created by Rajeshkumar on 01/06/18.
//  Copyright © 2018 Rajeshkumar. All rights reserved.
//

import UIKit

class InputOTPVC: UIViewController {
	
	//var RetrivedConfirmationPin = ""
	var RetrivedConfirmationPin = String()
	var RetrivedPhonenum = String()
	@IBOutlet weak var OTPLbl: UILabel!
	var RetrivedcustId = Int()
	var RetrivedempId = Int()
	@IBOutlet weak var OTPtextLbl: UILabel!
	@IBOutlet weak var VerificationcodeLbl: UILabel!
	@IBOutlet weak var PopupView: UIView!
	
	//MARK:- IBOutlet Properties
	@IBOutlet weak var tf1: UITextField!
	@IBOutlet weak var tf2: UITextField!
	@IBOutlet weak var tf3: UITextField!
	@IBOutlet weak var tf4: UITextField!
	@IBOutlet weak var buttonContinue: UIButton!
	
	//MARK:- IBAction
	
	//var OTP = Int()  // initializer syntax
	var OTP = Int()
	var otpstringValue = String()
	var empPresistedFaceId = String()
	var RetrivedMobileNumber = String()
	var InputFacestr = String()
	var Employeenamestr = String()
	override func viewDidLoad() {
		super.viewDidLoad()
		
		customActivityIndicatory(self.view, startAnimate: false)
		
		let defaults = UserDefaults.standard
		empPresistedFaceId = defaults.string(forKey: "empPresistedFaceId")!
		print("Mobile empPresistedFaceId-----",empPresistedFaceId)
		
		Employeenamestr = defaults.string(forKey: "employeeName")!
		print("Mobile Emp name-----",Employeenamestr)
		InputFacestr = UserDefaults.standard.string(forKey: "Facestr") ?? ""
		print("InputFacestr-----",InputFacestr)
		RetrivedMobileNumber = UserDefaults.standard.string(forKey: "Mobilenum") ?? ""
		print("RetrivedMobileNumber-----",RetrivedMobileNumber)
		PopupView.isHidden = true
		var OtpLblstr1 = "We have sent the OTP to +91 "
		var OTPLblfullstr = OtpLblstr1 + RetrivedMobileNumber
		OTPtextLbl.text = OTPLblfullstr
		VerifiedOTP()
		// var returnValue: [datatype]? = UserDefaults.standard.object(forKey: "otpNo") as? [datatype]
		
		//        let defaults = UserDefaults.standard
		//        RetrivedConfirmationPin = defaults.string(forKey: "otpNo")!
		//        RetrivedPhonenum = defaults.string(forKey: "mobile")!
		//
		//
		//
		//        print("RetrivedConfirmationPin",RetrivedConfirmationPin)
		//        print("RetrivedPhonenum",RetrivedPhonenum)
		//
		//        var FirstVerificationcodestr = "Send to 4 digit pin This mobile number "
		//        var SecondVerificationcodestr = RetrivedPhonenum
		//
		//        VerificationcodeLbl.text = FirstVerificationcodestr + SecondVerificationcodestr
		//
		// Do any additional setup after loading the view.
		setUpView()
		
		//self.view.backgroundColor = #colorLiteral(red: 0.1529411765, green: 0.1960784314, blue: 0.3882352941, alpha: 1)
		
	}
	
	
	
	@IBAction func textEditDidBegin(_ sender: UITextField) {
		print("textEditDidBegin has been pressed")
		
		if !(sender.text?.isEmpty)!{
			sender.selectAll(self)
			//buttonUnSelected()
		}else{
			print("Empty")
			sender.text = " "
			
		}
		
	}
	@IBAction func textEditChanged(_ sender: UITextField) {
		print("textEditChanged has been pressed")
		let count = sender.text?.count
		//
		if count == 1{
			
			switch sender {
			case tf1:
				tf2.becomeFirstResponder()
			case tf2:
				tf3.becomeFirstResponder()
			case tf3:
				tf4.becomeFirstResponder()
			case tf4:
				tf4.resignFirstResponder()
			default:
				print("default")
			}
		}
		
	}
	
	
	@IBAction func Verified_OkBtnclk(_ sender: Any) {
		
		let storyBoard = UIStoryboard(name: "Main", bundle:nil)
		let FaceRegistrationVC = storyBoard.instantiateViewController(withIdentifier: "FaceRegistrationVC") as! FaceRegistrationVC
		self.navigationController?.pushViewController(FaceRegistrationVC, animated:true)
		//self.present(FaceRegistrationVC, animated:true, completion:nil)
		
		//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
		//
		//        let FaceRegistrationVC = storyBoard.instantiateViewController(withIdentifier: "FaceRegistrationVC") as! FaceRegistrationVC
		//        self.present(FaceRegistrationVC, animated:true, completion:nil)
		
		
	}
	
	@IBAction func cancel(_ sender: Any) {
		
		self.navigationController?.popViewController(animated: true)
		
	}
	func VerifiedOTP()
	{
		let defaults = UserDefaults.standard
		RetrivedcustId = defaults.integer(forKey: "custId")
		print("RetrivedcustId----",RetrivedcustId)
		RetrivedempId = defaults.integer(forKey: "empId")
		print("RetrivedempId----",RetrivedempId)
		let parameters = ["refCustId": RetrivedcustId as Any,
						  "empId":  RetrivedempId as Any] as [String : Any];
		
		var StartPoint = Baseurl.shared().baseURL
		var Endpoint = "/attnd-api-gateway-service/api/customer/employee/setup/generateOtp"
		
		let url: NSURL = NSURL(string:"\(StartPoint)\(Endpoint)")!
		
		
		customActivityIndicatory(self.view, startAnimate: true)
		
		//create the session object
		let session = URLSession.shared
		
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
		
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			guard let data = data, error == nil else {
				print(error?.localizedDescription ?? "No data")
				return
			}
			let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
			if let responseJSON = responseJSON as? [String: Any] {
				print("Json Response",responseJSON)
				let statusDic = responseJSON["status"]! as! NSDictionary
				print("statusDic---",statusDic)
				DispatchQueue.main.async {
					self.customActivityIndicatory(self.view, startAnimate: false)
					let code = statusDic["code"] as? NSInteger
					print("code-----",code as Any)
					
					if(code == 200)
					{    let ItemsDict = responseJSON["otpDto"] as! NSDictionary
						//var otp : Int
						self.OTP = (ItemsDict["otp"] as? NSInteger)!
						print("OTP ------------",self.OTP as Any)
						self.otpstringValue = "\(String(describing: self.OTP))"
						self.OTPLbl.text = self.otpstringValue
						print("success---")
						
					}
					else
					{
						
						let statusDic = responseJSON["status"]! as! NSDictionary
						print("statusDic---",statusDic)
						let message = statusDic["message"] as? NSString
						print("message-----",message as Any)
						var alert = UIAlertController(title: "Failure", message: message as! String, preferredStyle: UIAlertController.Style.alert)
						alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
						self.present(alert, animated: true, completion:nil)
						print("Failure---")
					}
					
				}
			}
			
		}
		task.resume()
		
	}
	
	
	
	@IBAction func continueAction(_ sender: UIButton) {
		
		let str = "\(tf1.text!)\(tf2.text!)\(tf3.text!)\(tf4.text!)"
		print("str numbers-----",str)
		
		if (otpstringValue == str)
		{
			
			
			//                    if (InputFacestr != "")
			//                    {
			//                        print("Dashboard")
			//
			//
			//
			//
			//                        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
			//                        let UITabBarController = storyBoard.instantiateViewController(withIdentifier: "UITabBarController") as! UITabBarController
			//                        self.navigationController?.pushViewController(UITabBarController, animated:false)
			//
			//
			//
			//
			//                    }
			//else if (InputFacestr == "")
			
			if (empPresistedFaceId == "")
				
			{
				print("Calling second dashboard Part")
				print("Login success")
				PopupView.isHidden = false
				print("Calling first Part")
				
			}
			else
			{
				print("Secode one")
				let storyBoard = UIStoryboard(name: "Main", bundle:nil)
				let UITabBarController = storyBoard.instantiateViewController(withIdentifier: "UITabBarController") as! UITabBarController
				self.navigationController?.pushViewController(UITabBarController, animated:false)
				
				
			}
			
		}
		else
		{
			print("Login Failure")
			
			var alert = UIAlertController(title: "Failure", message: "Incorrect OTP", preferredStyle: UIAlertController.Style.alert)
			alert.addAction(UIAlertAction(title: "Okay!!", style: UIAlertAction.Style.default, handler: nil))
			self.present(alert, animated: true, completion: nil)
			
		}
	}
	
	
	//MARK:- Custom Action
	func setUpView(){
		tf1.setBorder()
		tf2.setBorder()
		tf3.setBorder()
		tf4.setBorder()
		
		tf1.delegate = self
		tf2.delegate = self
		tf3.delegate = self
		tf4.delegate = self
		tf1.becomeFirstResponder()
		
		buttonUnSelected()
	}
	
	func buttonUnSelected(){
		//buttonContinue.layer.borderWidth = 1
		//buttonContinue.backgroundColor = #colorLiteral(red: 0.831372549, green: 0.6862745098, blue: 0.2156862745, alpha: 1)
		//submitBtn.backgroundColor = #colorLiteral(red: 0.831372549, green: 0.6862745098, blue: 0.2156862745, alpha: 1)
		
		
		//buttonContinue.layer.cornerRadius = 20
		
		//        buttonContinue.layer.borderColor = Constants.Color.SavanColor.cgColor
		//        buttonContinue.setTitleColor(Constants.Color.SavanColor, for: .normal)
		//        buttonContinue.isUserInteractionEnabled = false
	}
	func checkAllFilled(){
		
		if (tf1.text?.isEmpty)! || (tf2.text?.isEmpty)! || (tf3.text?.isEmpty)! || (tf4.text?.isEmpty)!{
			buttonUnSelected()
		}else{
			buttonSelected()
		}
	}
	
	func buttonSelected(){
		buttonContinue.layer.borderWidth = 0
		buttonContinue.backgroundColor = Constants.Color.SavanColor
		
		buttonContinue.setTitleColor(UIColor.white, for: .normal)
		buttonContinue.isUserInteractionEnabled = true
	}
	
}

extension InputOTPVC : UITextFieldDelegate{
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		textField.text = ""
		if textField.text == "" {
			print("Backspace has been pressed")
		}
		
		if string == ""
		{
			print("Backspace was pressed")
			switch textField {
			case tf2:
				tf1.becomeFirstResponder()
			case tf3:
				tf2.becomeFirstResponder()
			case tf4:
				tf3.becomeFirstResponder()
			default:
				print("default")
			}
			textField.text = ""
			return false
		}
		
		return true
	}
	func textFieldDidEndEditing(_ textField: UITextField) {
		checkAllFilled()
	}
	
	
	
	
	func customActivityIndicatory(_ viewContainer: UIView, startAnimate:Bool? = true) -> UIActivityIndicatorView {
		let mainContainer: UIView = UIView(frame: viewContainer.frame)
		mainContainer.center = viewContainer.center
		mainContainer.backgroundColor = UIColor.init(netHex: 0xFFFFFF)
		
		
		mainContainer.alpha = 0.5
		mainContainer.tag = 789456123
		mainContainer.isUserInteractionEnabled = false
		
		let viewBackgroundLoading: UIView = UIView(frame: CGRect(x:0,y: 0,width: 80,height: 80))
		viewBackgroundLoading.center = viewContainer.center
		// viewBackgroundLoading.backgroundColor = UIColor.init(netHex: 0x444444)
		
		viewBackgroundLoading.backgroundColor = UIColor.darkGray
		
		viewBackgroundLoading.alpha = 0.5
		viewBackgroundLoading.clipsToBounds = true
		viewBackgroundLoading.layer.cornerRadius = 15
		
		let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
		activityIndicatorView.frame = CGRect(x:0.0,y: 0.0,width: 40.0, height: 40.0)
		activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
		activityIndicatorView.center = CGPoint(x: viewBackgroundLoading.frame.size.width / 2,
											   y: viewBackgroundLoading.frame.size.height / 2)
		if startAnimate!{
			viewBackgroundLoading.addSubview(activityIndicatorView)
			mainContainer.addSubview(viewBackgroundLoading)
			viewContainer.addSubview(mainContainer)
			activityIndicatorView.startAnimating()
		}else{
			for subview in viewContainer.subviews{
				if subview.tag == 789456123{
					subview.removeFromSuperview()
				}
			}
		}
		return activityIndicatorView
	}
	
}
