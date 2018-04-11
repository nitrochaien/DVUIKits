//
//  DragAndDropFlowLayout.swift
//  GroooVideoEditor
//
//  Created by Nam Vu on 4/6/18.
//  Copyright © 2018 Grooo International. All rights reserved.
//

import UIKit

//This is for iOS 10 or lower
class DragAndDropFlowLayout: UICollectionViewFlowLayout {
    var longPress: UILongPressGestureRecognizer!
    var originalIndexPath: IndexPath?
    var draggingIndexPath: IndexPath?
    var draggingView: UIView?
    var dragOffset = CGPoint.zero
    
    override func prepare() {
        super.prepare()
        
        addGestureRecognizer()
    }
    
    func addGestureRecognizer() {
        if longPress == nil {
            longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
            longPress.minimumPressDuration = 0.2
            collectionView?.addGestureRecognizer(longPress)
        }
    }
    
    @objc func handleLongPress(_ longPress: UILongPressGestureRecognizer) {
        guard let collectionView = collectionView else { return }
        let location = longPress.location(in: collectionView)
        switch longPress.state {
        case .began:
            startDragAtLocation(location)
        case .changed:
            updateDragAtLocation(location)
        case .ended:
            endDragAtLocation(location)
        default:
            break
        }
    }
    
    func startDragAtLocation(_ location: CGPoint) {
        guard let cv = collectionView else { return }
        guard let indexPath = cv.indexPathForItem(at: location) else { return }
        guard cv.dataSource?.collectionView!(cv, canMoveItemAt: indexPath) == true else { return }
        guard let cell = cv.cellForItem(at: indexPath) else { return }
        
        originalIndexPath = indexPath
        draggingIndexPath = indexPath
        draggingView = cell.snapshotView(afterScreenUpdates: true)
        draggingView!.frame = cell.frame
        cv.addSubview(draggingView!)
        
        dragOffset = CGPoint(x: draggingView!.center.x - location.x, y: draggingView!.center.y - location.y)
        
        draggingView?.layer.shadowPath = UIBezierPath(rect: draggingView!.bounds).cgPath
        draggingView?.layer.shadowColor = UIColor.black.cgColor
        draggingView?.layer.shadowOpacity = 0.8
        draggingView?.layer.shadowRadius = 10
        
        invalidateLayout()
        
        UIView.animate(withDuration: 0.4, animations: {
            self.draggingView?.alpha = 0.95
            self.draggingView?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: nil)
    }
    
    func updateDragAtLocation(_ location: CGPoint) {
        guard let view = draggingView else { return }
        guard let cv = collectionView else { return }
        
        view.center = CGPoint(x: location.x + dragOffset.x, y: location.y + dragOffset.y)
        
        if let newIndexPath = cv.indexPathForItem(at: location) {
            cv.moveItem(at: draggingIndexPath!, to: newIndexPath)
            draggingIndexPath = newIndexPath
        }
    }
    
    func endDragAtLocation(_ location: CGPoint) {
        guard let dragView = draggingView else { return }
        guard let indexPath = draggingIndexPath else { return }
        guard let cv = collectionView else { return }
        guard let datasource = cv.dataSource else { return }
        
        let targetCenter = datasource.collectionView(cv, cellForItemAt: indexPath).center
        
        let shadowFade = CABasicAnimation(keyPath: "shadowOpacity")
        shadowFade.fromValue = 0.8
        shadowFade.toValue = 0
        shadowFade.duration = 0.4
        dragView.layer.add(shadowFade, forKey: "shadowFade")
        
        UIView.animate(withDuration: 0.4, animations: {
            dragView.center = targetCenter
            dragView.transform = CGAffineTransform.identity
        }) { (completed) in
            if !indexPath.elementsEqual(self.originalIndexPath!) {
                datasource.collectionView!(cv, moveItemAt: self.originalIndexPath!, to: indexPath)
            }
            dragView.removeFromSuperview()
            self.draggingIndexPath = nil
            self.draggingView = nil
            self.invalidateLayout()
        }
    }
}
