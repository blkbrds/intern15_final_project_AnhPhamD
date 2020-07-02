//
//  TagViewModel.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 6/30/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation

final class TagCellViewModel {

    // MARK: - Properties
    var tagName: String

    // MARK: - Init
    init(tagGroup: TagGroup) {
        self.tagName = tagGroup.tagName
    }
}
