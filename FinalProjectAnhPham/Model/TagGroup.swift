//
//  TagGroup.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 6/30/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation

class TagGroup {
    var tagName: String
    
    init(json: JSON) {
        if let tagName = json["strCategory"] as? String {
            self.tagName = tagName
        } else {
            self.tagName = ""
        }
    }
}
