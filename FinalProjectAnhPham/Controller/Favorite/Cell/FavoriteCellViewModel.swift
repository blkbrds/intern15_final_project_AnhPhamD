//
//  FavoriteCellViewModel.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/15/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation

final class FavoriteCellViewModel {
    var drinkID: String
    var isFavorite: Bool
    var nameTitle: String
    var imageURL: String
    
    init(drink: Drink) {
        self.drinkID = drink.drinkID
        self.isFavorite = drink.isFavorite
        self.nameTitle = drink.nameTitle
        self.imageURL = drink.imageURL
    }
}
