//
//  ImageViewController.swift
//  SimpleUIKit
//
//  Created by Nam Dinh Vu on 2/5/17.
//  Copyright © 2017 hiworld. All rights reserved.
//

import UIKit

class ImageViewController: BaseViewController
{
    @IBOutlet var mScrollView: UIScrollView!
    @IBOutlet var mImageView: UIImageView!
    @IBOutlet var mTempImageView: UIImageView!
    
    var mouseSwiped:Bool = false
    var lastPoint:CGPoint!
    
    let red:CGFloat = 0.0/255.0
    let green:CGFloat = 0.0/255.0
    let blue:CGFloat = 0.0/255.0
    let brush:CGFloat = 10.0
    let opacity:CGFloat = 1.0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        mScrollView.minimumZoomScale = 0.5
        mScrollView.maximumZoomScale = 6.0
        mScrollView.contentSize = mImageView.frame.size
        mScrollView.delegate = self
        mScrollView.showsVerticalScrollIndicator = false
        mScrollView.showsHorizontalScrollIndicator = false
        
        self.view.bringSubview(toFront: mImageView)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        mScrollView.addGestureRecognizer(doubleTap)
        
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate))
        mScrollView.addGestureRecognizer(rotationGesture)
        rotationGesture.delegate = self
    }
}

extension ImageViewController: UIScrollViewDelegate
{
    func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        return mImageView.superview
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat)
    {
        
    }
    
    @objc func handleDoubleTap(_ recognizer: UITapGestureRecognizer)
    {
        if mScrollView.zoomScale == 1
        {
            mScrollView.zoom(to: zoomRectForScale(scale: mScrollView.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        }
        else
        {
            mScrollView.setZoomScale(1, animated: true)
        }
    }
    
    @objc func handleRotate(_ recognizer: UIRotationGestureRecognizer)
    {
        mImageView.transform = CGAffineTransform(rotationAngle: recognizer.rotation)
        recognizer.rotation = 0
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect
    {
        var zoomRect = CGRect.zero
        zoomRect.size.height = mImageView.frame.size.height / scale
        zoomRect.size.width  = mImageView.frame.size.width  / scale
        let newCenter = mImageView.convert(center, from: mScrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
}

extension ImageViewController: UIGestureRecognizerDelegate
{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return true
    }
}

extension ImageViewController
{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.bringSubview(toFront: mTempImageView)
        mouseSwiped = false
        if let touch = touches.first
        {
            lastPoint = touch.location(in: self.view)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        mouseSwiped = true
        if let touch = touches.first
        {
            let currentPoint:CGPoint = touch.location(in: self.view)
            
            UIGraphicsBeginImageContext(self.view.frame.size)
            mTempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            let context = UIGraphicsGetCurrentContext()
            context?.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
            context?.addLine(to: CGPoint(x: currentPoint.x, y: currentPoint.y))
            context?.setLineCap(.round)
            context?.setLineWidth(brush)
            context?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
            context?.setBlendMode(.normal)
            context?.strokePath()
            
            mTempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
            mTempImageView.alpha = opacity
            UIGraphicsEndImageContext()
            
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if !mouseSwiped
        {
            UIGraphicsBeginImageContext(self.view.frame.size)
            mTempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            let context = UIGraphicsGetCurrentContext()
            context?.setLineCap(.round)
            context?.setLineWidth(brush)
            context?.setStrokeColor(red: red, green: green, blue: blue, alpha: opacity)
            context?.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
            context?.addLine(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
            context?.strokePath()
            context?.flush()
            
            mTempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        //merge tempImage to image
        UIGraphicsBeginImageContext(mImageView.frame.size)
        mImageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), blendMode: .normal, alpha: 1.0)
        mTempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), blendMode: .normal, alpha: opacity)
        mImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        mTempImageView.image = nil
        UIGraphicsEndImageContext()
        
        self.view.bringSubview(toFront: mImageView)
    }
}
