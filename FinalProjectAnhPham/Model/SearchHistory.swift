//
//  SearchHistory.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/21/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import RealmSwift

final class SearchHistory: Object {
    @objc dynamic var searchKey: String = ""
}
