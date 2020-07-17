//
//  HomeCellViewModel.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 6/30/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

final class DrinkTableCellViewModel {

    // MARK: - Properties
    var name: String
    var isFavorite: Bool
    var imageURL: String
    var thumbnailImage: UIImage?

    // MARK: - Init
    init(drink: Drink) {
        self.name = drink.nameTitle
        self.isFavorite = drink.isFavorite
        self.imageURL = drink.imageURL
//        self.thumbnailImage = drink.thumbnailImage
    }
}
