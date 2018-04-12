//
//  DropAndDragViewController.swift
//  SimpleUIKit
//
//  Created by Nam Vu on 4/11/18.
//  Copyright © 2018 self. All rights reserved.
//

import UIKit

class DropAndDragViewController: UIViewController {
    @IBOutlet weak var sourceCV: UICollectionView!
    @IBOutlet weak var destinationCV: UICollectionView!
    
    private var sourceItems = ["none", "chrome", "fade", "falseColor", "instant", "mono", "noir", "process", "sepia", "tonal", "transfer"]
    private var destinationItems = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.sourceCV.dragInteractionEnabled = true
        self.sourceCV.dragDelegate = self
        self.sourceCV.dropDelegate = self
        self.sourceCV.dataSource = self
        
        self.destinationCV.dragInteractionEnabled = true
        self.destinationCV.dropDelegate = self
        self.destinationCV.dragDelegate = self
        self.destinationCV.reorderingCadence = .fast
        self.destinationCV.dataSource = self
        
        sourceCV.register(UINib(nibName: "DropAndDragCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        destinationCV.register(UINib(nibName: "DropAndDragCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
    }

    private func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
    {
        let items = coordinator.items
        if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath
        {
            var dIndexPath = destinationIndexPath
            if dIndexPath.row >= collectionView.numberOfItems(inSection: 0)
            {
                dIndexPath.row = collectionView.numberOfItems(inSection: 0) - 1
            }
            collectionView.performBatchUpdates({
                if collectionView === self.destinationCV
                {
                    self.destinationItems.remove(at: sourceIndexPath.row)
                    self.destinationItems.insert(item.dragItem.localObject as! String, at: dIndexPath.row)
                }
                else
                {
                    self.sourceItems.remove(at: sourceIndexPath.row)
                    self.sourceItems.insert(item.dragItem.localObject as! String, at: dIndexPath.row)
                }
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [dIndexPath])
            })
            coordinator.drop(items.first!.dragItem, toItemAt: dIndexPath)
        }
    }
    
    private func copyItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
    {
        collectionView.performBatchUpdates({
            var indexPaths = [IndexPath]()
            for (index, item) in coordinator.items.enumerated()
            {
                let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                if collectionView === self.destinationCV
                {
                    self.destinationItems.insert(item.dragItem.localObject as! String, at: indexPath.row)
                }
                else
                {
                    self.sourceItems.insert(item.dragItem.localObject as! String, at: indexPath.row)
                }
                indexPaths.append(indexPath)
            }
            collectionView.insertItems(at: indexPaths)
        })
    }
}

extension DropAndDragViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == self.sourceCV ? self.sourceItems.count : destinationItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DropAndDragCell
        let item = collectionView == sourceCV ? sourceItems[indexPath.item] : destinationItems[indexPath.item]
        
        if collectionView == sourceCV {
            cell.label.text = item
            cell.backgroundColor = .red
        } else {
            cell.label.text = item
            cell.backgroundColor = .blue
        }
        return cell
    }
}

extension DropAndDragViewController : UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = collectionView == sourceCV ? sourceItems[indexPath.item] : destinationItems[indexPath.item]
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        let item = collectionView == sourceCV ? sourceItems[indexPath.item] : destinationItems[indexPath.item]
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        
        return [dragItem]
    }
    
//    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
//        if collectionView == sourceCV {
//            let previewParams = UIDragPreviewParameters()
//            previewParams.visiblePath = UIBezierPath(rect: CGRect(x: <#T##CGFloat#>, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>))
//        }
//    }
}

extension DropAndDragViewController : UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView == sourceCV {
            if collectionView.hasActiveDrag {
                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            } else {
                return UICollectionViewDropProposal(operation: .forbidden)
            }
        } else {
            if collectionView.hasActiveDrag {
                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            } else {
                return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        switch coordinator.proposal.operation {
        case .move:
            reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
            break
        case .copy:
            copyItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
            break
        default:
            return
        }
    }
}
