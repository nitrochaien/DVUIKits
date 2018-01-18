//
//  ObjectDetectionViewController.swift
//  SimpleUIKit
//
//  Created by Nam Vu on 11/22/17.
//  Copyright © 2017 self. All rights reserved.
//

import UIKit

class ObjectDetectionViewController: BaseViewController {
    
    var buttonCameraDetection = UIButton()
    var buttonImageDetection = UIButton()
    var buttonTextDetection = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonCameraDetection.translatesAutoresizingMaskIntoConstraints = false
        buttonCameraDetection.setTitle("Camera Detection", for: .normal)
        buttonCameraDetection.setTitleColor(.white, for: .normal)
        buttonCameraDetection.backgroundColor = .gray
        buttonCameraDetection.addTarget(self, action: #selector(onClick), for: .touchUpInside)
        
        view.addSubview(buttonCameraDetection)
        
        buttonImageDetection.translatesAutoresizingMaskIntoConstraints = false
        buttonImageDetection.setTitle("Image Detection", for: .normal)
        buttonImageDetection.setTitleColor(.white, for: .normal)
        buttonImageDetection.backgroundColor = .gray
        buttonImageDetection.addTarget(self, action: #selector(onClick), for: .touchUpInside)
        
        view.addSubview(buttonImageDetection)

        buttonTextDetection.translatesAutoresizingMaskIntoConstraints = false
        buttonTextDetection.setTitle("Text Detection", for: .normal)
        buttonTextDetection.setTitleColor(.white, for: .normal)
        buttonTextDetection.backgroundColor = .gray
        buttonTextDetection.addTarget(self, action: #selector(onClick), for: .touchUpInside)
        
        view.addSubview(buttonTextDetection)
        
        let viewDicts = ["btnCam" : buttonCameraDetection,
                         "btnImg" : buttonImageDetection,
                         "btnTxt" : buttonTextDetection]
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[btnCam]-[btnImg]-[btnTxt]", options: NSLayoutFormatOptions(rawValue: 0), metrics: [:], views: viewDicts))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[btnCam]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: [:], views: viewDicts))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[btnImg]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: [:], views: viewDicts))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[btnTxt]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: [:], views: viewDicts))
    }
    
    @objc func onClick(_ sender: UIButton) {
        if sender == buttonCameraDetection {
            let controller = CameraObjectDetectionViewController()
            navigationController?.pushViewController(controller, animated: true)
        } else if sender == buttonImageDetection {
            let storyboard = UIStoryboard(name: "ImageDetect", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ImageObjectDetectionViewController")
            navigationController?.pushViewController(controller, animated: true)
        } else if sender == buttonTextDetection {
            let controller = TextDetectionViewController()
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
