//
//  NewFeaturesTableViewController.swift
//  SimpleUIKit
//
//  Created by Nam Vu on 11/29/17.
//  Copyright © 2017 self. All rights reserved.
//

import UIKit

class NewFeaturesTableViewController: BaseViewController, UISearchResultsUpdating {
    
    //MARK: UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewRespectsSystemMinimumLayoutMargins = false
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        createCustomTestMarginView()
    }
    
    func createCustomTestMarginView() {
        let customView = UIView()
        customView.layoutMargins = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        customView.translatesAutoresizingMaskIntoConstraints = false
//        customView.directionalLayoutMargins.leading = 30
        customView.backgroundColor = .purple
        
        view.addSubview(customView)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[customView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["customView" : customView]))
    }
}
