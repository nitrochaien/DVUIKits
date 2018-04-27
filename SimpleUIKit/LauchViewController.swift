//
//  LauchViewController.swift
//  SimpleUIKit
//
//  Created by Nam Vu on 4/20/18.
//  Copyright © 2018 self. All rights reserved.
//

import UIKit

class LauchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 70/255, green: 154/255, blue: 233/255, alpha: 1)
        navigationController?.isNavigationBarHidden = true
        
        addTwitterLogo()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ViewController")
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    fileprivate func addTwitterLogo() {
        let mask = CALayer()
        guard let image = UIImage(named: "twitter_logo") else {
            print("Image not available")
            return
        }
        mask.contents = image.cgImage
        mask.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        mask.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        mask.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        
        view.layer.mask = mask
        
        animate(mask)
    }
    
    fileprivate func animate(_ mask: CALayer) {
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "bounds")
        keyFrameAnimation.duration = 1
        keyFrameAnimation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut), CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)]
        let initalBounds = NSValue(cgRect: mask.bounds)
        let secondBounds = NSValue(cgRect: CGRect(x: 0, y: 0, width: 90, height: 90))
        let finalBounds = NSValue(cgRect: CGRect(x: 0, y: 0, width: 1500, height: 1500))
        keyFrameAnimation.values = [initalBounds, secondBounds, finalBounds]
        keyFrameAnimation.keyTimes = [0, 0.3, 1]
        mask.add(keyFrameAnimation, forKey: "bounds")
    }
}
