//
//  RecognitionCamera.swift
//  LiveRecognition
//
//  Created by Anton on 11/03/2019.
//  Copyright © 2019 Luxand, Inc. All rights reserved.
//

import Foundation
import AVKit

class RecognitionCamera : NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?;
    var captureSession: AVCaptureSession?;
    var videoInput: AVCaptureDeviceInput?;
    var videoOutput: AVCaptureVideoDataOutput?;
    var delegate: RecognitionCameraDelegate?;
    var width: Int32 = 0;
    var height: Int32 = 0;
    
    init(position: AVCaptureDevice.Position) {
        super.init();
        
        do {
        
            // Grab the front-facing camera
            var camera: AVCaptureDevice? = nil;
            let devices: [AVCaptureDevice] = AVCaptureDevice.devices(for: AVMediaType.video);
            for device in devices {
                if (device.position == position) {
                    camera = device;
                }
            }
            
            // Create the capture session
            captureSession = AVCaptureSession.init();
            
            // Add the video input
            videoInput = try AVCaptureDeviceInput.init(device: camera!)
            let canAddInput = captureSession?.canAddInput(videoInput!)
            if (canAddInput == true) {
                captureSession?.addInput(videoInput!);
            }

            // Create VideoPreviewLayer
            videoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: captureSession!);
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill;
            
            // Add the video frame output
            videoOutput = AVCaptureVideoDataOutput.init();
            videoOutput?.alwaysDiscardsLateVideoFrames = true;
            
            // Use RGB frames instead of YUV to ease color processing
            videoOutput?.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable as! String: NSNumber(value: kCVPixelFormatType_32BGRA)];
            
            videoOutput?.setSampleBufferDelegate(self, queue: DispatchQueue.main);
            let canAddOutput = captureSession?.canAddOutput(videoOutput!);
            if (canAddOutput == true) {
                captureSession?.addOutput(videoOutput!);
            }
            
            if (UIDevice().userInterfaceIdiom == .phone && camera?.supportsSessionPreset(AVCaptureSession.Preset.iFrame960x540) == true) {
                
                captureSession?.sessionPreset = AVCaptureSession.Preset.iFrame960x540;
                width = 960;
                height = 540;
            } else {
                captureSession?.sessionPreset = AVCaptureSession.Preset.vga640x480;
                width = 640;
                height = 480;
            }
            
            if (captureSession?.isRunning != true) {
                captureSession?.startRunning();
            }
            
        } catch {
            print("Error in RecognitionCamera.initWithPosition");
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let pixelBuffer: CVImageBuffer? = CMSampleBufferGetImageBuffer(sampleBuffer);
        delegate?.processNewCameraFrame(cameraFrame: pixelBuffer!);
    }

    deinit {
        captureSession?.stopRunning();
    }
}

protocol RecognitionCameraDelegate {
    func cameraHasConnected();
    func processNewCameraFrame(cameraFrame: CVImageBuffer);
}
