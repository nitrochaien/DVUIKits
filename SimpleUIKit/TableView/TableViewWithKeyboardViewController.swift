//
//  TableViewWithKeyboardViewController.swift
//  SimpleUIKit
//
//  Created by Nam Vu on 2/21/18.
//  Copyright © 2018 self. All rights reserved.
//

import UIKit

class TableViewWithKeyboardViewController: UIViewController,
    UITableViewDelegate, UITableViewDataSource,
    UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerButton: UIButton!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    let sectionNames = ["Artists", "Footballers", "Search Input"]
    let section1 = ["Ed Sheeran", "Taylor Swift", "ABBA", "Modern Talking", "Demi Lovato", "Miley Cyrus"]
    let section2 = ["Eden Hazard", "Ronaldo", "Messi"]
    var section3: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        title = "TableView with Keyboard"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        
        searchBar.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //MARK: TableView DataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        if indexPath.section == 0 {
            cell.textLabel?.text = section1[indexPath.row]
        } else if indexPath.section == 1 {
            cell.textLabel?.text = section2[indexPath.row]
        } else  {
            cell.textLabel?.text = section3[indexPath.row]
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return section1.count
        }
        if section == 1 {
            return section2.count
        }
        return section3.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }
    
    //MARK: Search Bar Delegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
        if searchText.isEmpty {
            return
        }
        
        section3.append(searchText)
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    //MARK: Keyboard Observers
    @objc func handleKeyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height

            tableViewBottomConstraint.constant = keyboardHeight
        } else {
            tableViewBottomConstraint.constant = 0
        }
    }
    
    @objc func handleKeyboardWillHide(_ notification: Notification) {
        tableViewBottomConstraint.constant = 0
    }
}
