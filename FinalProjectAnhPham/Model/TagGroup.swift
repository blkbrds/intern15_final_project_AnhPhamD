//
//  TagGroup.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 6/30/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation

final class TagGroup {

    // MARK: - Properties
    var tagName: String

    // MARK: - Init
    init(json: JSON) {
        if let tagName = json["strCategory"] as? String {
            self.tagName = tagName
        } else if let tagName = json["strGlass"] as? String {
            self.tagName = tagName
        } else if let tagName = json["strAlcoholic"] as? String {
            self.tagName = tagName
        } else {
            self.tagName = ""
        }
    }
}
