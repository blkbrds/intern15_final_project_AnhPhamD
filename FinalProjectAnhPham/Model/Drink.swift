//
//  Drink.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 6/30/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation

final class Drink {
    
    // MARK: - Properties
    var name: String
    var isFavorite: Bool
    
    // MARK: - Init
    init(name: String, isFavorite: Bool = false) {
        self.name = name
        self.isFavorite = isFavorite
    }
}
