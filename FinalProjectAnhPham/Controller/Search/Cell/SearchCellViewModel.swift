//
//  SearchCellViewModel.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/16/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation

final class SearchCellViewModel {

    // MARK: - Properties
    var nameTitle: String
    var idDrink: String
    var isFavorite: Bool
    var imageURL: String

    // MARK: - Init
    init(drink: Drink) {
        self.nameTitle = drink.nameTitle
        self.idDrink = drink.idDrink
        self.isFavorite = drink.isFavorite
        self.imageURL = drink.imageURL
    }
}
