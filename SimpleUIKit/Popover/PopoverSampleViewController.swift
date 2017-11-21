//
//  PopoverSampleViewController.swift
//  SimpleUIKit
//
//  Created by Nam Vu on 11/11/17.
//  Copyright © 2017 hiworld. All rights reserved.
//

import UIKit

class PopoverSampleViewController: UIViewController {
    
    var popover: Popover!
    
    let popoverList = [(key: 1, value: "Steaks"),
                       (key: 2, value: "Pizza"),
                       (key: 3, value: "Pasta"),
                       (key: 4, value: "Fries"),
                       (key: 5, value: "Burger")]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton()
        button.frame.size = CGSize(width: 50, height: 100)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Click to show Popover", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(onClick), for: .touchUpInside)
        
        view.addSubview(button)
        
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: button, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: button, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    @objc func onClick(_ sender: UIButton) {
        setupPopover(sender, title: nil)
    }
    
    func setupPopover(_ sender: UIView, title: String?) {
        if popover == nil {
            popover = Popover(sender, title: "", handler: { data in
                print("Selected value is ", data.value)
            })
        } else {
            popover.setSourceView(sender)
        }
        popover.list = popoverList
        popover.popoverInfiniteHeight = true
        popover.reloadData()
        if presentedViewController != popover {
            present(popover, animated: true, completion: nil)
        }
    }
}
