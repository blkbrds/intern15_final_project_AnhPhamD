//
//  Drink.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 6/30/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

final class Drink {

    // MARK: - Properties
    var name: String
    var isFavorite: Bool
    var imageURL: String
    var thumbnailImage: UIImage?

    // MARK: - Init
    init(json: JSON, isFavorite: Bool = false) {
        if let name = json["strDrink"] as? String {
            self.name = name
        } else {
            self.name = ""
        }
        self.isFavorite = isFavorite
        
        if let imageName = json["strDrinkThumb"] as? String {
            self.imageURL = imageName
        } else {
            self.imageURL = ""
        }
    }
}
