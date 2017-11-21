//
//  SampleTableViewController.swift
//  SimpleUIKit
//
//  Created by Dinh Vu Nam on 7/13/17.
//  Copyright © 2017 hiworld. All rights reserved.
//

//  This contains a TableView with default cell configurations
//  Hiding navigation bar feature
//  Drag and Drop cell features

import UIKit

class SampleTableViewController: UIViewController {
    
    var manager: HidingNavigationBarManager!
    
    var data = [String]()
    var originalData = ["Shendelzare Silkwood: Vengeful Spirit", "Abaddon: Lord of Avernus", "Pugna: Oblivion", "Crixalis: Sand King", "Clinkz: Bone Fletcher", "Luna Moonfang: Moon Rider", "Bradwarden: Centaur Warchief", "Zeus: Lord of Olympus", "Black Arachnia: Broodmother", "Leshrac the Malicious: Tormented Soul", "Aiushtha: Enchantress", "Morphling: Morphling", "Kardel Sharpeye: Dwarven Sniper", "Jah'rakal: Troll Warlord", "Leviathan: Tidehunter", "Rhasta: Shadow Shaman", "Atropos: Bane Elemental", "Rotund'jere: Necrolyte", "Pudge: Butcher", "Darkterror: Faceless Void", "Anub'seran: Nerubian Weaver", "Mogul Khan: Axe", "Rylai Crestfall: Crystal Maiden", "Strygwyr: Bloodseeker", "Lucifer: Doom Bringer", "Sven: Rogue Knight", "Rigwarl: Bristleback", "Slithice: Naga Siren", "Raigor Stonehoof: Earthshaker", "Gondar: Bounty Hunter", "Magina: Anti-Mage", "Rexxar: Beastmaster", "Traxex: Drow Ranger", "Jakiro: Twin Head Dragon", "Purist Thunderwrath: Omniknight", "Razzil Darkbrew: Alchemist", "Knight Davion: Dragon Knight", "Mercurial: Spectre", "Mirana Nightshade: Priestess of the Moon", "Mangix: Pandaren Brewmaster", "Raijin Thunderkeg: Storm Spirit", "Alleria: Windrunner", "Huskar: Sacred Warrior", "Slardar: Slithereen Guard", "Lanaya: Templar Assassin", "Demnok Lannik: Warlock", "Puck: Faerie Dragon", "Vol'Jin: Witch Doctor", "Rikimaru: Stealth Assassin", "Rattletrap: Clockwerk Goblin", "Daelin Proudmoore: Admiral", "Syllabear: Lone Druid", "Razor: Lightning Revenant", "Lina Inverse: Slayer", "Harbinger: Obsidian Destroyer", "Yurnero: Juggernaut", "Medusa: Gorgon", "Meepo: Geomancer", "Balanar: Night Stalker", "King Leoric: Skeleton King", "Dazzle: Shadow Priest", "Anub'arak: Nerubian Assassin", "Rubick: Grand Magus", "Azgalor: Pit Lord", "Viper: Netherdrake", "Akasha: Queen of Pain", "Nevermore: Shadow Fiend", "Kel'thuzad: Lich", "Ish'kafel: Dark Seer", "Kael: Invoker", "Dirge: Undying", "Nortrom: Silencer", "Mortred: Phantom Assassin", "Darchrow: Enigma", "Rooftrellen: Treant Protector", "Ulfsaar: Ursa Warrior", "Aggron Stonebreaker: Ogre Magi", "Boush: Tinker", "Furion: Prophet", "Azwraith: Phantom Lancer", "Tiny: Stone Giant", "Lesale Deathbringer: Venomancer", "Squee Spleen and Spoon: Goblin Techies", "Chen: Holy Knight", "Krobelus: Death Prophet", "Terrorblade: Soul Keeper", "Magnus: Magnataur", "Lion: Demon Witch", "Visage: Necro'lic", "Nessaj: Chaos Knight", "Banehallow: Lycanthrope", "Cairne Bloodhoof: Tauren Chieftain", "Jin'zakk: Batrider", "N'aix: Lifestealer", "Ezalor: Keeper of the Light", "Barathrum: Spiritbreaker", "Slark: Murloc Nightcrawler", "Kaldr: Ancient Apparition", "Aurel Vlaicu: Gyrocopter", "Io: Guardian Wisp", "Thrall: Disruptor", "Eredar: Shadow Demon", "Icarus: Phoenix", "Ymir: Tuskarr", "Rizzrak: Goblin Shredder", "Xin: Ember Spirit", "Dragonus: Skywrath Mage", "Tresdin: Legion Commander", "Zet: Arc Warden", "Auroth: Winter Wyvern", "Kaolin: Earth Spirit", "Nerif: Oracle"]
    
    var tableview: UITableView!
    var refreshControl: UIRefreshControl!
    var searcher: UISearchBar!
    var noDataLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initToolbar()
        
        addDragAndDrop()
    }
    
    func initialize() {
        initTableView()
        initNoDataLabel()
        
        manager = HidingNavigationBarManager.init(viewController: self, scrollView: tableview)
        
        initData()
    }
    
    func initTableView() {
        tableview = UITableView.init(frame: self.view.bounds)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.tableFooterView = UIView.init(frame: CGRect.zero)
        tableview.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        setupPullToRefresh()
        view.addSubview(tableview)
    }
    
    func initNoDataLabel() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        noDataLabel = UILabel.init(frame: CGRect.init(x: 8, y: screenHeight / 2, width: screenWidth - 16, height: 50))
        noDataLabel.isHidden = true
        noDataLabel.text = "Cant find any heroes"
        noDataLabel.lineBreakMode = .byWordWrapping
        noDataLabel.numberOfLines = 0
        noDataLabel.textAlignment = .center
        view.addSubview(noDataLabel)
    }
    
    func initData() {
        data = originalData
        tableview.reloadData()
    }
    
    func deinitData() {
        data.removeAll()
        tableview.reloadData()
    }
    
    func initToolbar() {
        searcher = UISearchBar()
        searcher.delegate = self
        searcher.becomeFirstResponder()
        searcher.barStyle = .blackTranslucent
        navigationItem.titleView = searcher
    }
    
    func addDragAndDrop() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(onLongPressRecognizer))
        tableview.addGestureRecognizer(longPress)
    }
    
    @objc func onLongPressRecognizer(_ sender: UILongPressGestureRecognizer) {
        let state = sender.state
        let locationInView = sender.location(in: tableview)
        let indexPath = tableview.indexPathForRow(at: locationInView)
        
        switch state {
        case .began:
            if let indexPath = indexPath {
                MyPath.initialIndexPath = indexPath
                guard let cell = tableview.cellForRow(at: indexPath) as UITableViewCell! else { return }
                MyCell.cellSnapshot = snapshotOfCell(cell)
                
                guard let cellSnapshot = MyCell.cellSnapshot else { return }
                var center = cell.center
                cellSnapshot.center = center
                cellSnapshot.alpha = 0
                tableview.addSubview(cellSnapshot)
                
                UIView.animate(withDuration: 0.25, animations: {
                    center.y = locationInView.y
                    cellSnapshot.center = center
                    cellSnapshot.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    cellSnapshot.alpha = 0.98
                    cell.alpha = 0
                }, completion: { (finished) in
                    if finished {
                        MyCell.cellIsAnimating = false
                        if MyCell.cellNeedToShow {
                            MyCell.cellNeedToShow = false
                            UIView.animate(withDuration: 0.25, animations: {
                                cell.alpha = 1
                            })
                        } else {
                            cell.isHidden = true
                        }
                    }
                })
            }
            break
            
        case UIGestureRecognizerState.changed:
            guard let cellSnapshot = MyCell.cellSnapshot else { return }
            var center = cellSnapshot.center
            center.y = locationInView.y
            cellSnapshot.center = center
            
            guard let indexPath = indexPath else { return }
            if (indexPath != MyPath.initialIndexPath) {
                guard let initialPath = MyPath.initialIndexPath else { return }
                
                if let lastCell = tableview.visibleCells.last {
                    if let lastRow = tableview.indexPath(for: lastCell)?.row {
                        if MyPath.initialIndexPath?.row == lastRow {
                            if lastRow < data.count - 1 {
                                tableview.contentOffset.y += 44
                            }
                        }
                    }
                }
                data.swapAt(initialPath.row, indexPath.row)
                tableview.moveRow(at: initialPath, to: indexPath)
                MyPath.initialIndexPath = indexPath
            }
            break
            
        default:
            guard let initialIndexPath = MyPath.initialIndexPath else { return }
            guard let cell = tableview.cellForRow(at: initialIndexPath) as UITableViewCell! else { return }
            if MyCell.cellIsAnimating {
                MyCell.cellNeedToShow = true
            } else {
                cell.isHidden = false
                cell.alpha = 0.0
            }
            
            guard let cellSnapshot = MyCell.cellSnapshot else { return }
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                cellSnapshot.center = cell.center
                cellSnapshot.transform = CGAffineTransform.identity
                cellSnapshot.alpha = 0.0
                cell.alpha = 1.0
                
            }, completion: { (finished) -> Void in
                if finished {
                    MyPath.initialIndexPath = nil
                    cellSnapshot.removeFromSuperview()
                    MyCell.cellSnapshot = nil
                }
            })
        }
    }
    
    func snapshotOfCell(_ inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let cellSnapshot: UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5, height: 0)
        cellSnapshot.layer.shadowRadius = 5
        cellSnapshot.layer.shadowOpacity = 0.4
        
        return cellSnapshot
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        manager.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        manager.viewWillDisappear(animated)
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        manager.shouldScrollToTop()
        return true
    }
}

extension SampleTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "cell")
        cell.selectionStyle = .none
        
        let name = data[indexPath.row]
        cell.textLabel?.text = name
        cell.imageView?.image = #imageLiteral(resourceName: "dota2_logo.png")
        cell.detailTextLabel?.text = "Defense of the Ancient"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func setupPullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableview.addSubview(refreshControl)
    }
    
    @objc func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            guard self.searcher != nil else {
                self.refreshControl.endRefreshing()
                return
            }
            guard let searchText = self.searcher.text else {
                self.refreshControl.endRefreshing()
                return
            }
            self.refreshFilteredData(searchText)
            self.refreshControl.endRefreshing()
        }
    }
}

extension SampleTableViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
        refreshFilteredData(searchText)
    }
    
    func refreshFilteredData(_ searchText: String) {
        if searchText.isEmpty {
            initData()
        } else {
            doSearch(searchText)
        }
    }
    
    func doSearch(_ input: String) {
        data.removeAll()
        for name in originalData {
            if name.contains(input) {
                data.append(name)
            }
        }
        tableview.reloadData()
        handleSearchResult()
    }
    
    func handleSearchResult() {
        noDataLabel.isHidden = data.count != 0
    }
}

struct MyCell {
    static var cellSnapshot: UIView? = nil
    static var cellIsAnimating: Bool = false
    static var cellNeedToShow: Bool = false
}

struct MyPath {
    static var initialIndexPath: IndexPath? = nil
}
