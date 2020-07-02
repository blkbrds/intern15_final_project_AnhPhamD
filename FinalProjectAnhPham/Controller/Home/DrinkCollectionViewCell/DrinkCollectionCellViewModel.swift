//
//  DrinkCollectionCellViewModel.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 6/30/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

final class DrinkCollectionCellViewModel {
    var name: String
    var thumbnailImage: UIImage?
    var isFavorite: Bool
    init(drink: Drink) {
        self.name = drink.name
        self.thumbnailImage = drink.thumbnailImage
        self.isFavorite = drink.isFavorite
    }
}
