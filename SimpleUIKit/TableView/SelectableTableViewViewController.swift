//
//  SelectableTableViewViewController.swift
//  SimpleUIKit
//
//  Created by Nam Vu on 1/18/18.
//  Copyright © 2018 self. All rights reserved.
//

import UIKit

class SelectableTableViewViewController: UIViewController {
    
    var tableView: UITableView!
    
    let firstSectionSourceData = [DefaultSection(title: "a1", isFlagged: false), DefaultSection(title: "b1", isFlagged: false), DefaultSection(title: "c1", isFlagged: false)]
    let secondSectionSourceData = [DefaultSection(title: "a2", isFlagged: false), DefaultSection(title: "b2", isFlagged: false), DefaultSection(title: "c2", isFlagged: false)]
    
    var firstSectionData: [DefaultSection] = []
    var secondSectionData: [DefaultSection] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initDataSource()
    }
    
    private func initView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "defaultCell")
        
        self.view.addSubview(tableView)
    }
    
    private func initDataSource() {
        firstSectionData = firstSectionSourceData
        secondSectionData = secondSectionSourceData
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SelectableTableViewViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "defaultCell")
        
        if (indexPath.section == 0) {
            cell.textLabel?.text = firstSectionData[indexPath.row].title
        } else {
            cell.textLabel?.text = secondSectionData[indexPath.row].title
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? firstSectionData.count : secondSectionData.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Section 1" : "Section 2"
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = contextualDeleteAction(indexPath)
        let flagAction = contextualFlagAction(indexPath)
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction, flagAction])
        
        return swipeConfig
    }
    
    func contextualDeleteAction(_ indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Delete", handler: { (action, sourceView, boll) in
            if indexPath.section == 0 {
                self.firstSectionData.remove(at: indexPath.row)
            } else {
                self.secondSectionData.remove(at: indexPath.row)
            }
            self.tableView.reloadData()
        })
        action.backgroundColor = .red
        
        return action
    }
    
    func contextualFlagAction(_ indexPath: IndexPath) -> UIContextualAction {
        var defaultSection: DefaultSection!
        
        if indexPath.section == 0 {
            defaultSection = firstSectionData[indexPath.row]
        } else {
            defaultSection = secondSectionData[indexPath.row]
        }
    
        let action = UIContextualAction(style: .normal, title: "Flag", handler: { (action, sourceView, boll) in
            if indexPath.section == 0 {
                self.firstSectionData[indexPath.row].toggleFlag()
            } else {
                self.secondSectionData[indexPath.row].toggleFlag()
            }
            self.tableView.reloadData()
        })
        action.backgroundColor = defaultSection.isFlagged ? .orange : .gray
        
        return action
    }
}

struct DefaultSection {
    let title: String
    var isFlagged: Bool
    
    mutating func toggleFlag() {
        isFlagged = !isFlagged
    }
}
