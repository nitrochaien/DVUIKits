//
//  ImagePickerController.swift
//  SimpleUIKit
//
//  Created by Nam Dinh Vu on 1/15/17.
//  Copyright © 2017 hiworld. All rights reserved.
//

import UIKit
import Photos

protocol ImagePickerControllerDelegate
{
    func onViewControllerForResult(selectedPictures: [SSFile])
    func onChooseOneFileResult(selectedFile: PHAsset)
}

class ImagePickerController: UIViewController
{
    @IBOutlet var mCollectionView: UICollectionView!
    let mReuseIdentifier = "PickerCell"
    var mListPhotos = [FileObject]()
    var mItemSize: CGFloat = 0
    var mPictures: NSMutableOrderedSet!
    var mSelectedPictures = [FileObject]()
    var delegate: ImagePickerControllerDelegate?
    var mSelectedFile:FileObject!
    
    var mIsChooseMultipleFiles:Bool = true
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        configCollectionView()
        checkPermission()
        initActionBar()
    }
    
    func checkPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized {
                    self.initData()
                }
            })
        } else if status == .authorized {
            initData()
        } else if status == .denied {
            print("Do not have permission!")
        }
    }
    
    func configCollectionView()
    {
        mCollectionView.delegate = self
        mCollectionView.dataSource = self
        mCollectionView.allowsMultipleSelection = true
        mCollectionView.allowsSelection = true
        setColumn()
    }
    
    func initData()
    {
        //fetch all photos assets
        let allPhotos = PHAsset.fetchAssets(with: .image, options: nil)
           
        guard allPhotos.count > 0 else {
            return
        }
        
        for i in 0...allPhotos.count-1
        {
            mListPhotos.append(FileObject(asset: allPhotos[i]))
        }
        
        mCollectionView.reloadData()
    }
    
    func initActionBar()
    {
        let buttonShare = UIBarButtonItem(title: "Share",
                                          style: .plain,
                                          target: self,
                                          action: #selector(sharePictures))
        navigationItem.rightBarButtonItem = buttonShare
    }
    
    @objc func sharePictures()
    {
        if checkSelectedPictures() == true
        {
            if mSelectedFile != nil
            {
                delegate?.onChooseOneFileResult(selectedFile: mSelectedFile.asset)
            }
            else
            {
                print("Did not choose file")
            }
        }
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func checkSelectedPictures() -> Bool
    {
        if delegate == nil
        {
            print("Chua set delegate")
            return false
        }
        
        if mSelectedPictures.count == 0
        {
            print("Chua chon anh nao")
            return false
        }
        return true
    }
    
    func setColumn()
    {
        let screenWidth = UIScreen.main.bounds.size.width
        var itemWidth: CGFloat = 0
        var itemHeight: CGFloat = 0
        let linespaceMin: CGFloat = 20
        let itemMarginTop: CGFloat = 0
        var itemMarginLeft: CGFloat = 0
        let itemMarginBottom: CGFloat = 0
        var itemMarginRight: CGFloat = 0
        var numberOfColumn: CGFloat = 0
        
        let flowLayout = UICollectionViewFlowLayout()
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            numberOfColumn = 2
            break
        case .pad:
            numberOfColumn = 3
            break
        default:
            break
        }
        
        if numberOfColumn == 2
        {
            itemWidth = screenWidth*0.4
            itemMarginLeft = 20
            itemMarginRight = 20
        }
        else if numberOfColumn == 3
        {
            itemWidth = screenWidth*0.26
            itemMarginRight = 35
            itemMarginLeft = 35
        }
        itemHeight = itemWidth
        mItemSize = itemHeight
        
        flowLayout.itemSize = CGSize.init(width: itemWidth, height: itemHeight)
        flowLayout.minimumLineSpacing = linespaceMin
        flowLayout.sectionInset = UIEdgeInsetsMake(itemMarginTop, itemMarginLeft, itemMarginBottom, itemMarginRight)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        
        mCollectionView.collectionViewLayout = flowLayout
    }
}

extension ImagePickerController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mReuseIdentifier,
                                                      for: indexPath) as! PickerCell
        
        let aFileObject = mListPhotos[indexPath.row]
        PHImageManager.default().requestImage(for: aFileObject.asset,
                                              targetSize: CGSize(width: mItemSize, height: mItemSize),
                                              contentMode: PHImageContentMode.aspectFill,
                                              options: nil,
                                              resultHandler: {(result: UIImage?, info: [AnyHashable : Any]?) -> Void in
                                                cell.mImageView.image = result})
        
        if aFileObject.state == true
        {
            cell.mViewBounds.backgroundColor = UIColor.blue
        }
        else
        {
            cell.mViewBounds.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return mListPhotos.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print("Enter selected Item At Index path")
        handleTrigger(collectionView: collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
    {
        print("Enter deselected Item At Index path")
        handleTrigger(collectionView: collectionView, indexPath: indexPath)
    }
    
    func handleTrigger(collectionView: UICollectionView, indexPath: IndexPath)
    {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! PickerCell
        let row = indexPath.row
        let fileObject = mListPhotos[row]
        
        //item is selected, then deselect item
        if fileObject.state == true
        {
            let aFileObject = mListPhotos[indexPath.row]
            
            if mIsChooseMultipleFiles
            {
                for i in 0...mSelectedPictures.count
                {
                    let file = mSelectedPictures[i]
                    if file === aFileObject
                    {
                        mSelectedPictures.remove(at: i)
                        break
                    }
                }
            }
            else
            {
                mSelectedFile = nil
            }
            
            let selectedCell = collectionView.cellForItem(at: indexPath) as! PickerCell
            selectedCell.mViewBounds.backgroundColor = UIColor.white
            aFileObject.state = false
            
            print("deselected. state of item: ", aFileObject.state)
        }
            //item is not selected, select item
        else
        {
            selectedCell.mViewBounds.backgroundColor = UIColor.blue
            
            mSelectedPictures.append(fileObject)
            mSelectedFile = fileObject
            
            fileObject.state = true
            
            if !mIsChooseMultipleFiles
            {
                for file in mListPhotos
                {
                    if file.state == true && file !== fileObject
                    {
                        file.state = false
                    }
                }
                
                self.mCollectionView.reloadData()
            }
            print("selected. state of item: ", fileObject.state)
        }
    }
}
