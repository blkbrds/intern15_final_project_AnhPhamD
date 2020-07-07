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

    // MARK: - Properties
    var name: String
    var imageURL: String
    var isFavorite: Bool

    // MARK: - Init
    init(drink: Drink) {
        self.name = drink.name
        self.imageURL = drink.imageURL
        self.isFavorite = drink.isFavorite
    }
}
