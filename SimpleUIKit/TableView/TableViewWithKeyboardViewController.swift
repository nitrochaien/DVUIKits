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
    UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,
    UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchSelectionCV: UICollectionView!
    @IBOutlet weak var firstTextField: UITextField!
    
    let sectionNames = ["Artists", "Footballers", "Movie-stars"]
    let section1 = ["Ed Sheeran", "Taylor Swift", "ABBA", "Modern Talking", "Demi Lovato", "Miley Cyrus"]
    let section2 = ["Eden Hazard", "Ronaldo", "Messi"]
    var section3: [String] = ["The Rock", "Brad Pitt", "Julia Roberts"]
    var selectedItems: [String] = []
    
    var tfWidthConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        title = "TableView with Keyboard"
        edgesForExtendedLayout = []
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        
        searchView.layer.cornerRadius = 10
        
        searchSelectionCV.delegate = self
        searchSelectionCV.dataSource = self
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionFootersPinToVisibleBounds = true
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.minimumLineSpacing = 5
        flowLayout.footerReferenceSize = CGSize.zero
        searchSelectionCV.collectionViewLayout = flowLayout
        
        firstTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //MARK: UITableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.selectionStyle = .none
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item = ""
        if indexPath.section == 0 {
            item = section1[indexPath.row]
        } else if indexPath.section == 1 {
            item = section2[indexPath.row]
        } else {
            item = section3[indexPath.row]
        }
        selectedItems.append(item)
        reloadSearchView(.right, indexPath: indexPath)
    }
    
    //MARK: Text Field Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
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
    
    //MARK: UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectedCell", for: indexPath)
        cell.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        if let label = cell.viewWithTag(1) as? UILabel {
            label.text = selectedItems[indexPath.row]
            label.sizeToFit()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItems.remove(at: indexPath.row)
        reloadSearchView(.left, indexPath: indexPath)
    }
    
    //MARK: UICollectionView funcs
    func reloadSearchView(_ direction: UICollectionViewScrollPosition, indexPath: IndexPath) {
        if selectedItems.count > 0 {
            
        } else {
            
        }
        searchSelectionCV.reloadData()
        
        if searchSelectionCV.contentSize.width > searchSelectionCV.bounds.width {
            DispatchQueue.main.async {
                self.searchSelectionCV.scrollToItem(at: IndexPath(item: self.selectedItems.count - 1, section: 0), at: direction, animated: false)
            }
            
        }
    }
}
