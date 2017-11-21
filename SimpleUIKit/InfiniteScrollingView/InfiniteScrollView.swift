//
//  InfiniteScrollView.swift
//  SimpleUIKit
//
//  Created by Nam Vu on 11/17/17.
//  Copyright © 2017 hiworld. All rights reserved.
//

import UIKit
import Foundation
import SDWebImage

protocol InfiniteScrollViewDelegate {
    func didScrollToIndex(_ index: Int)
    func didSelectIndex(_ index: Int)
    func imageDownloaded()
}

class InfiniteScrollView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {

    open var imageURLs: [String]!
    open var currentIndex: Int = 0
    open var scrollDelegate: InfiniteScrollViewDelegate?
    open var image: UIImage!
    
    fileprivate var onceOnly: Bool = false
    fileprivate var swipeTimer: Timer!
    fileprivate let maxPage = 16
    fileprivate var maxHeight: CGFloat = 0
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        let flowLayout = layout as! UICollectionViewFlowLayout
//        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 200)
        flowLayout.scrollDirection = .horizontal
        
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }

    fileprivate func initialize() {
        backgroundColor = .clear
        isPagingEnabled = true

        delegate = self
        dataSource = self
        
        register(InfiniteCell.self, forCellWithReuseIdentifier: "cell")

        imageURLs = [String]()
    }
    
    fileprivate func startTimer() {
        if swipeTimer == nil {
            swipeTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(exactly: 2)!, repeats: true, block: { (time) in
                self.next()
            })
        }
    }
    
    fileprivate func stopTimer() {
        if swipeTimer != nil {
            swipeTimer.invalidate()
            swipeTimer = nil
        }
    }
    
    fileprivate func next() {
        scrollToItem(at: IndexPath(row: currentIndex, section: 0), at: .centeredHorizontally, animated: false)
        let nextIndex = IndexPath(row: currentIndex + 1, section: 0)
        scrollToItem(at: nextIndex, at: .centeredHorizontally, animated: true)
    }
    
    fileprivate func scrollToCenter(_ animate: Bool) {
        let count = imageURLs.count
        var index = currentIndex % count
        index = index + ((maxPage * count) / 2)
        currentIndex = index
        
        let indexPath = IndexPath(row: index, section: 0)
        scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animate)
    }
    
    //MARK: Collection View Delegate + Datasource
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !onceOnly {
            let count = imageURLs.count
            let index = currentIndex % count
            currentIndex = (maxPage * count) / 2 + index
            let indexPathToScrollTo = IndexPath(row: currentIndex, section: 0)
            collectionView.scrollToItem(at: indexPathToScrollTo, at: .centeredHorizontally, animated: false)
            onceOnly = true
            isUserInteractionEnabled = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if let subView = cell.viewWithTag(1) {
            let imageView = subView as! UIImageView
            let index = indexPath.row % imageURLs.count
            imageView.sd_setImage(with: URL(string: imageURLs[index]), placeholderImage: nil, options: .cacheMemoryOnly) { (image, err, type, url) in
                guard let image = image, err == nil else { return }
                
//                let imageWidth = self.frame.width
//                let imageHeight = (image.size.height / image.size.width) * imageWidth
//                imageView.frame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
                imageView.image = image
//                self.maxHeight = imageHeight > self.maxHeight ? imageHeight : self.maxHeight
                
                if imageView.tag == 1 {
                    self.image = image
                    self.scrollDelegate?.imageDownloaded()
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count * maxPage
    }
    
    func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        let offsetX = CGFloat(currentIndex) * bounds.width
        return CGPoint(x: offsetX, y: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row % imageURLs.count
        scrollDelegate?.didSelectIndex(index)
    }
    
    //MARK: Collection View Flow Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bounds.width, height: bounds.height)
    }
    
    //MARK: ScrollView Delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateScrolling(scrollView)
        startTimer()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updateScrolling(scrollView)
    }
    
    fileprivate func updateScrolling(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let currentPos = (scrollView.contentOffset.x - pageWidth / 2) / pageWidth
        let currentPage = floor(currentPos) + 1
        
        if currentIndex != Int(currentPage) && currentPage != 0 {
            currentIndex = Int(currentPage)
            
            let count = imageURLs.count
            let leftMax = count + 1
            let rightMin = count * (maxPage - 2)
            if currentIndex < leftMax || currentIndex > rightMin {
                self.scrollToCenter(false)
            }
            
            scrollDelegate?.didScrollToIndex(currentIndex)
            
            scrollToItem(at: IndexPath(row: currentIndex, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }
    
    //MARK: public functions
    open func setData(_ list: [String]) {
        imageURLs = [String]()
        
        DispatchQueue.main.async {
            self.reloadData()
            self.imageURLs = list
            
            self.onceOnly = false
            self.performBatchUpdates({}, completion: { (finished) in
                self.startTimer()
            })
        }
    }
    
    open func startAnimating() {
        startTimer()
    }
    
    open func stopAnimating() {
        stopTimer()
    }
}

class InfiniteCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }
    
    fileprivate func initialize() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        imageView.tag = 1
        imageView.contentMode = .scaleToFill
        
        addSubview(imageView)
    }
}
