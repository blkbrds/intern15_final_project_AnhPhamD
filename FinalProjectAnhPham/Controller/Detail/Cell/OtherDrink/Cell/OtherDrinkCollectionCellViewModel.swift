//
//  OtherDrinkCollectionViewModel.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/20/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation

final class OtherDrinkCollectionCellViewModel {

    // MARK: - Properties
    var nameTitle: String
    var imageURL: String
    var isFavorite: Bool
    var drinkID: String

    // MARK: - Init
    init(drink: Drink) {
        self.nameTitle = drink.nameTitle
        self.imageURL = drink.imageURL
        self.drinkID = drink.drinkID
        self.isFavorite = drink.isFavorite
    }
}
