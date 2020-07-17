//
//  DrinkCollectionCellViewModel.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 6/30/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation

final class DrinkCellViewModel {

    // MARK: - Properties
    var drinkID: String
    var nameTitle: String
    var imageURL: String
    var isFavorite: Bool

    // MARK: - Init
    init(drink: Drink) {
        self.drinkID = drink.drinkID
        self.nameTitle = drink.nameTitle
        self.imageURL = drink.imageURL
        self.isFavorite = drink.isFavorite
    }
}
