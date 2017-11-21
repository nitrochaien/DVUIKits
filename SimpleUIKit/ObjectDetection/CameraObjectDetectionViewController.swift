//
//  CameraObjectDetectionViewController.swift
//  SimpleUIKit
//
//  Created by Nam Vu on 11/9/17.
//  Copyright © 2017 hiworld. All rights reserved.
//

import UIKit
import AVKit
import Vision

class CameraObjectDetectionViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    let label = UILabel()

    fileprivate func createLayer(_ captureSession: AVCaptureSession) {
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
    }
    
    fileprivate func addLabel() {
        label.frame = CGRect(x: 0, y: 600, width: view.frame.size.width, height: 50)
        label.font = UIFont(name: label.font.fontName, size: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        view.addSubview(label)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }

        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        captureSession.addInput(input)
        captureSession.startRunning()
        
        createLayer(captureSession)
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        
        captureSession.addOutput(dataOutput)
        
        addLabel()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        guard let model = try? VNCoreMLModel(for: SqueezeNet().model) else { return }
        let request = VNCoreMLRequest(model: model) { (req, err) in
            guard let result = req.results as? [VNClassificationObservation] else { return }
            
            guard let firstObservation = result.first else { return }
            let resultString = "\(firstObservation.identifier)\t\(Int(firstObservation.confidence * 100))%"
            print(resultString)
            
            DispatchQueue.main.async {
                self.label.text = resultString
            }
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
}
