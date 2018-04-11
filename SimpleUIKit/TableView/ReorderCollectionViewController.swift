//
//  ReorderCollectionViewController.swift
//  SimpleUIKit
//
//  Created by Nam Vu on 4/9/18.
//  Copyright © 2018 self. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ReorderCollectionViewController: UICollectionViewController {
    
    var items = ["One0", "One1", "One2", "One3", "One4", "One5", "One6", "One7", "One8", "One9", "One10", "One11", "One12", "One13", "One14", "One15", "One16", "One17", "One18", "One19", "One20", "One21", "One22", "One23", "One24", "One25", "One26"]
//    var items = ["One", "Two", "Three", "Four", "Five", "Six", "Seven"]
    
    var layout: UICollectionViewLayout = {
        let flow = UICollectionViewFlowLayout()
        flow.itemSize = CGSize(width: 62, height: 62)
        flow.minimumInteritemSpacing = 16
        flow.minimumLineSpacing = 16
        flow.scrollDirection = .vertical
        return flow
    }()
    
    fileprivate var snapshotView: UIView?
    fileprivate var snapshotIndexPath: IndexPath?
    fileprivate var snapshotPanPoint: CGPoint?
    
    init() {
        super.init(collectionViewLayout: layout)
        installsStandardGestureForInteractiveMovement = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        installsStandardGestureForInteractiveMovement = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        //        self.collectionView!.register(DropAndDragCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.register(UINib(nibName: "DropAndDragCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        // Do any additional setup after loading the view.
        
        collectionView?.backgroundColor = .white
        collectionView?.contentInset = UIEdgeInsetsMake(44, 33, 44, 33)
        collectionView?.dragInteractionEnabled = true
        collectionView?.reorderingCadence = .fast
        
        collectionView?.reloadData()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture))
        collectionView!.addGestureRecognizer(longPressGesture)
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DropAndDragCell
        
        cell.layer.cornerRadius = 8
        cell.backgroundColor = .blue
        cell.label.text = items[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let temp = items.remove(at: sourceIndexPath.row)
        items.insert(temp, at: destinationIndexPath.item)
    }
    
    @objc func handleLongGesture(recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = collectionView!.indexPathForItem(at: recognizer.location(in: collectionView!)) else { break }
            collectionView!.beginInteractiveMovementForItem(at: selectedIndexPath)
        case UIGestureRecognizerState.changed:
            collectionView!.updateInteractiveMovementTargetPosition(recognizer.location(in: recognizer.view!))
        case UIGestureRecognizerState.ended:
            collectionView!.endInteractiveMovement()
        default:
            collectionView!.cancelInteractiveMovement()
        }
    }
}
