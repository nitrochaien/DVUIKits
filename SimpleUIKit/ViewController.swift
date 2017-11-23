//
//  ViewController.swift
//  SimpleUIKit
//
//  Created by Nam Dinh Vu on 11/21/17.
//  Copyright © 2017 self. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = []
        
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.largeTitleDisplayMode = .automatic
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onOpenInfiniteScrollView(_ sender: Any) {
        let controller = InfiniteScrollingViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func onOpenMap(_ sender: Any) {
        let storyboard = UIStoryboard(name: "map", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MapController")
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func onClickPopover(_ sender: Any) {
        let controller = PopoverSampleViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func onClickSimpleTableView(_ sender: Any) {
        let controller = SampleTableViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func onClickImagePicker(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ImagePicker", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ImagePickerController")
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func onClickFacialRecognition(_ sender: Any) {
        let controller = FacialRecogViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func onClickImageWithZoom(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Image", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ImageViewController")
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func onClickObjectDetection(_ sender: Any) {
        let controller = ObjectDetectionViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
}

