//
//  InitialPickerController.swift
//  SimpleUIKit
//
//  Created by Nam Dinh Vu on 1/15/17.
//  Copyright © 2017 hiworld. All rights reserved.
//

import UIKit
import Photos

class InitialPickerController: UIViewController
{
    @IBOutlet var mButtonPicker: UIButton!
    @IBOutlet var mLabelPath: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func onPicker(_ sender: Any)
    {
        performSegue(withIdentifier: "segueToPicker",
                     sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "segueToPicker"
        {
            let aImagePick = segue.destination as! ImagePickerController
            aImagePick.delegate = self
        }
    }
}

extension InitialPickerController: ImagePickerControllerDelegate
{
    //1 file
    func onChooseOneFileResult(selectedFile: PHAsset)
    {
        selectedFile.requestContentEditingInput(with: PHContentEditingInputRequestOptions()) { (input, _) in
            let url = input?.fullSizeImageURL
            let ssFile = SSFile(path: url!)
            
            self.mLabelPath.text = ssFile.path?.absoluteString
        }
    }
    
    //multiple files
    func onViewControllerForResult(selectedPictures: [SSFile])
    {
        
    }
}
