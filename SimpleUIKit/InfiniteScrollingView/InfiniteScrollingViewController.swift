//
//  InfiniteScrollingViewController.swift
//  SimpleUIKit
//
//  Created by Nam Vu on 11/17/17.
//  Copyright © 2017 hiworld. All rights reserved.
//

import UIKit

class InfiniteScrollingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = []
        title = "Infinite Scrolling"
        
        let width = UIScreen.main.bounds.width
        let height = width * 9 / 16
        
        let infiniteScrollView = InfiniteScrollView(frame: CGRect(x: 0, y: 0, width: width, height: height), collectionViewLayout: UICollectionViewFlowLayout())
        infiniteScrollView.backgroundColor = .green
        infiniteScrollView.setData(["https://cdn.mmos.com/wp-content/uploads/2015/09/685patchdota2.jpg",
                                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUSNDue2gOaUL3JgoN3o8ch-Yd0l_ZP7vbwV8IuPUvrSsTKibXfQ",
                                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjB9McVzLxiW7BkuTEdse_k5aAjflPE-f1amX1pvDgJndlVR6T"])
        
        view.addSubview(infiniteScrollView)
    }
}
