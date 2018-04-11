//
//  UICollectionViewController+Ext.swift
//  SimpleUIKit
//
//  Created by Nam Vu on 4/9/18.
//  Copyright © 2018 self. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

extension UICollectionViewController {
    func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, data: inout [String]) {
        guard let collectionView = self.collectionView else { return }
        
        let items = coordinator.items
        if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath
        {
            var dIndexPath = destinationIndexPath
            if dIndexPath.row >= collectionView.numberOfItems(inSection: 0)
            {
                dIndexPath.row = collectionView.numberOfItems(inSection: 0) - 1
            }
            collectionView.performBatchUpdates({
                data.remove(at: sourceIndexPath.row)
                data.insert(item.dragItem.localObject as! String, at: dIndexPath.row)
                
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [dIndexPath])
            })
            coordinator.drop(items.first!.dragItem, toItemAt: dIndexPath)
        }
    }
    
    //data is dataSource of destinationCollectionView
    func copyItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, destinationCollectionView: UICollectionView, data: inout [String])
    {
        guard let collectionView = self.collectionView else { return }
        
        collectionView.performBatchUpdates({
            var indexPaths = [IndexPath]()
            for (index, item) in coordinator.items.enumerated()
            {
                let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                data.insert(item.dragItem.localObject as! String, at: indexPath.row)
                indexPaths.append(indexPath)
            }
            collectionView.insertItems(at: indexPaths)
        })
    }
}
