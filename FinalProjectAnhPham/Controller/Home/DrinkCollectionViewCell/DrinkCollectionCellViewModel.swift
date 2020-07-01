//
//  DrinkCollectionCellViewModel.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 6/30/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation

final class DrinkCollectionCellViewModel {
    var name: String
    
    init(drink: Drink) {
        self.name = drink.name
    }
}
