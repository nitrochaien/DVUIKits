//
//  SSFile.swift
//  SimpleRTC
//
//  Created by Dau Quang Hung on 12/19/16.
//  Copyright © 2016 HungDQ. All rights reserved.
//

import Foundation

class SSFile {
    var path: URL?
    var name: String?
    var ext: String?
    var size: UInt64?
    var md5: String?
    
    private init() {}
    
    public init(path: URL) {
        self.path = path
        let fileName = path.lastPathComponent
        self.name = (fileName as NSString).deletingPathExtension
        self.ext = (fileName as NSString).pathExtension
    }
}
