//
//  FavoriteCellViewModel.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/15/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation

final class FavoriteCellViewModel {
    var idDrink: String
    var isFavorite: Bool
    var nameTitle: String
    var imageURL: String
    
    init(drink: Drink) {
        self.idDrink = drink.idDrink
        self.isFavorite = drink.isFavorite
        self.nameTitle = drink.nameTitle
        self.imageURL = drink.imageURL
    }
}
