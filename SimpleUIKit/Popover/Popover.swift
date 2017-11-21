//
//  Popover.swift
//  SimpleUIKit
//
//  Created by Nam Vu on 11/9/17.
//  Copyright © 2017 hiworld. All rights reserved.
//

import UIKit

public typealias DVTuple<Int> = (key: Int, value: String)
public typealias CompletionHandler = (_ data: DVTuple<Int>) -> ()

open class Popover: UIViewController {
    
    open var sender = UIView()
    open var popoverTitle: String?
    open var popoverTextColor: UIColor = .blue
    open var popoverTitleColor: UIColor = .black
    open var popoverFont: UIFont?
    open var list = [DVTuple<Int>]()
    open var arrowDirection: UIPopoverArrowDirection = .any
    open var popoverBackgroundColor: UIColor = .black
    open var size: CGSize = CGSize(width: 250, height: 150)
    open var popoverBorderWidth: CGFloat = 1
    open var popoverBorderColor: UIColor = .black
    open var popoverInfiniteHeight: Bool = false
    
    fileprivate var titleLabel = UILabel()
    fileprivate var barHeight: CGFloat = 44
    fileprivate var handler: CompletionHandler?
    fileprivate var tableView: UITableView!
    fileprivate var navigationBar: UINavigationBar!
    
    fileprivate let cellIdentifier = "cell"
    fileprivate let defaultCellHeight = 44
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        addNavigationBar()
        addTableView()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setProperties()
    }
    
    public init(_ sender: UIView, title: String?, handler: CompletionHandler?) {
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .popover
        setSourceView(sender)
        self.sender = sender
        self.popoverTitle = title
        self.handler = handler
        
        if title == nil || (title?.isEmpty)! {
            self.barHeight = 0
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: open funcs
    open func reloadData() {
        if tableView != nil {
            titleLabel.text = popoverTitle ?? ""
            tableView.reloadData()
        }
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    open func setSourceView(_ sender: UIView) {
        guard let vc = popoverPresentationController else { return }
        vc.sourceView = sender
        vc.sourceRect = sender.bounds
        vc.delegate = self
    }
    
    // MARK: private funcs
    fileprivate func addNavigationBar() {
        if notShowNavigationBar() { return }
        
        navigationBar = UINavigationBar()
        titleLabel = UILabel()
        navigationBar.addSubview(titleLabel)
        view.addSubview(navigationBar)
    }
    
    fileprivate func addTableView() {
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        view.addSubview(tableView)
    }
    
    fileprivate func setNavigationBar() {
        if notShowNavigationBar() { return }
        navigationBar.frame = CGRect(x: 0, y: 0, width: size.width, height: barHeight)
        setTitleLabel()
    }
    
    fileprivate func setTitleLabel() {
        titleLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: barHeight)
        titleLabel.backgroundColor = .clear
        titleLabel.text = popoverTitle
        titleLabel.textColor = popoverTitleColor
        titleLabel.font = popoverFont ?? UIFont(name: titleLabel.font.fontName, size: 17)
        titleLabel.textAlignment = .center
    }
    
    fileprivate func setTableView() {
        tableView.frame = CGRect(x: 0, y: barHeight, width: size.width, height: size.height - barHeight)
        tableView.separatorInset.left = 0
    }
    
    fileprivate func setProperties() {
        guard let vc = popoverPresentationController else { return }
        vc.permittedArrowDirections = arrowDirection
        vc.backgroundColor = popoverBackgroundColor
        
        if popoverInfiniteHeight {
            size = CGSize(width: size.width, height: CGFloat(list.count * defaultCellHeight))
            tableView.isScrollEnabled = false
        } else {
            if list.count < 4 {
                size = CGSize(width: size.width, height: CGFloat(list.count * defaultCellHeight))
                tableView.isScrollEnabled = false
            }
        }
        
        preferredContentSize = size
        view.frame.size = size
        view.superview?.layer.cornerRadius = 0
        view.superview?.layer.borderWidth = popoverBorderWidth
        view.superview?.layer.borderColor = popoverBorderColor.cgColor
        
        setNavigationBar()
        setTableView()
    }
    
    fileprivate func notShowNavigationBar() -> Bool {
        guard let titleString = title, titleString.isEmpty else { return false }
        if barHeight > 0 { return false }
        return true
    }
}

extension Popover : UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as UITableViewCell!
        cell.textLabel?.text = list[indexPath.row].value
        cell.textLabel?.font = popoverFont ?? UIFont(name: titleLabel.font.fontName, size: 15)
        cell.textLabel?.textColor = popoverTextColor
        cell.selectionStyle = .none
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
        guard let handler = handler else { return }
        handler(list[indexPath.row])
    }
}

extension Popover : UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
