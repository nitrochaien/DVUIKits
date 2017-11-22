//
//  FacialRecogViewController.swift
//  SimpleUIKit
//
//  Created by Nam Dinh Vu on 10/29/17.
//  Copyright © 2017 hiworld. All rights reserved.
//

import UIKit
import Vision

class FacialRecogViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let image = UIImage(named: "ngot_band") else { return }
        
        let imageView = UIImageView(image: image)
        
        let scaledHeight = view.frame.width / image.size.width * image.size.height
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .blue
        imageView.frame = CGRect(x: 0, y: 64, width: view.frame.width, height: scaledHeight)
        view.addSubview(imageView)
        
        if #available(iOS 11.0, *) {
            let request = VNDetectFaceRectanglesRequest { (req, err) in
                if let err = err {
                    print("Cant detect: ", err)
                    return
                }
                
                req.results?.forEach({ (result) in
                    
                    DispatchQueue.main.async {
                        guard let faceObs = result as? VNFaceObservation else { return }
                        
                        let x = self.view.frame.width * faceObs.boundingBox.origin.x
                        let height = scaledHeight * faceObs.boundingBox.height
                        let width = self.view.frame.width * faceObs.boundingBox.width
                        let y = scaledHeight * (1 - faceObs.boundingBox.origin.y) - height + 64
                        
                        let redView = UIView()
                        redView.backgroundColor = .red
                        redView.alpha = 0.4
                        redView.frame = CGRect(x: x, y: y, width: width, height: height)
                        self.view.addSubview(redView)
                    }
                })
            }
            
            guard let cgImage = image.cgImage else { return }
            
            DispatchQueue.global(qos: .background).async {
                let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                do {
                    try handler.perform([request])
                } catch let err {
                    print("Failed to perform request: ", err)
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
}
