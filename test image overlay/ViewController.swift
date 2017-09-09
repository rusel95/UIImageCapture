//
//  ViewController.swift
//  test image overlay
//
//  Created by Admin on 9/9/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController {
    let captureSession = AVCaptureSession()
    let stillImageOutput = AVCaptureStillImageOutput()
    var error: NSError?
    override func viewDidLoad() {
        super.viewDidLoad()
        let devices = AVCaptureDevice.devices().filter{ ($0 as AnyObject).hasMediaType(AVMediaTypeVideo) && ($0 as AnyObject).position == AVCaptureDevicePosition.front }
        if let captureDevice = devices.first as? AVCaptureDevice  {
            captureSession.addInput( try! AVCaptureDeviceInput( device: captureDevice ) )
            captureSession.sessionPreset = AVCaptureSessionPresetPhoto
            captureSession.startRunning()
            stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
            }
            if let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) {
                previewLayer.bounds = view.bounds
                previewLayer.position = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
                previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                let cameraPreview = UIView(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.size.width, height: view.bounds.size.height) )
                cameraPreview.layer.addSublayer(previewLayer)
                cameraPreview.addGestureRecognizer( UITapGestureRecognizer(target: self, action: #selector( saveToCamera(sender:) ) ) )
                view.addSubview(cameraPreview)
            }
        }
    }
    
    func saveToCamera(sender: UITapGestureRecognizer) {
        if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo) {
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection) {
                (imageDataSampleBuffer, error) -> Void in
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                UIImageWriteToSavedPhotosAlbum(UIImage(data: imageData!)!, nil, nil, nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

