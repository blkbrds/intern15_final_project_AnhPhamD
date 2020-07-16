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
    var idDrink: String
    var nameTitle: String
    var imageURL: String
    var isFavorite: Bool

    // MARK: - Init
    init(drink: Drink) {
        self.idDrink = drink.idDrink
        self.nameTitle = drink.nameTitle
        self.imageURL = drink.imageURL
        self.isFavorite = drink.isFavorite
    }
    
//    func checkFavorite(idDrink: String) -> Bool {
//        do {
//            let realm = try Realm()
//            let results = realm.objects(Drink.self).filter("idDrink = '\(idDrink)'")
//            if results.isEmpty {
//               return false
//            } else {
//               return true
//            }
//        } catch {
//            print(error)
//        }
//        return false
//    }
}
