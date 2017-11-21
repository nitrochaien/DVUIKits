//
//  FileObject.swift
//  SimpleUIKit
//
//  Created by Nam Dinh Vu on 1/15/17.
//  Copyright © 2017 hiworld. All rights reserved.
//

import UIKit
import Photos

class FileObject: NSObject
{
    var ssFile: SSFile?
    var state: Bool!
    var asset: PHAsset!
    
    init(asset: PHAsset)
    {
        ssFile = nil
        state = false
        self.asset = asset
    }
}
