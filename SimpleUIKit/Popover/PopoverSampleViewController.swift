//
//  PopoverSampleViewController.swift
//  SimpleUIKit
//
//  Created by Nam Vu on 11/11/17.
//  Copyright © 2017 hiworld. All rights reserved.
//
// This also contains select text to show UIMenuController

import UIKit

class PopoverSampleViewController: BaseViewController {
    
    var popover: Popover!
    
    let popoverList = [(key: 1, value: "Steaks"),
                       (key: 2, value: "Pizza"),
                       (key: 3, value: "Pasta"),
                       (key: 4, value: "Fries"),
                       (key: 5, value: "Burger")]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buttonPopover = UIButton()
        buttonPopover.frame.size = CGSize(width: 50, height: 100)
        buttonPopover.translatesAutoresizingMaskIntoConstraints = false
        buttonPopover.setTitle("Click to show Popover", for: .normal)
        buttonPopover.setTitleColor(.blue, for: .normal)
        buttonPopover.addTarget(self, action: #selector(onClick), for: .touchUpInside)
        
        view.addSubview(buttonPopover)
        
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: buttonPopover, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: buttonPopover, attribute: .centerY, multiplier: 1, constant: 0))
        
        let textFieldMenu = UITextField()
        textFieldMenu.frame = CGRect(x: 100, y: 44, width: 50, height: 100)
        textFieldMenu.text = "Show menu from textfield"
        textFieldMenu.layer.borderColor = UIColor.gray.cgColor
        textFieldMenu.layer.cornerRadius = 5
        textFieldMenu.layer.borderWidth = 1
        
        let menu = UIMenuController.shared
        menu.setTargetRect(CGRect.zero, in: textFieldMenu)
        let menuItem = UIMenuItem(title: "Custom action", action: #selector(onClickCustomAction))
        menu.menuItems = [menuItem]
        menu.arrowDirection = .up
        menu.setMenuVisible(true, animated: true)
        
        view.addSubview(textFieldMenu)
    }
    
    @objc func onClick(_ sender: UIButton) {
        setupPopover(sender, title: nil)
    }
    
    @objc func onClickCustomAction() {
        
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
