//
//  FavoriteViewModel.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/13/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import RealmSwift

class FavoriteViewModel {
    
    var status: MenuItem
    var drinks: [Drink] = []
    var isFavorite: Bool = false
    
    init(status: MenuItem = .category) {
        self.status = status
    }

    func fetchRealmData(completion: (Bool) -> Void) {
        do {
            // Realm
            let realm = try Realm()
            // Create results
            let results = realm.objects(Drink.self)
            // Convert to array
            drinks = Array(results)
            // Call back
            completion(true)
        } catch {
            completion(false)
        }
    }
    
    func deleteItemFavorite(idDrink: String, completion: @escaping (Bool) -> Void) {
        do {
            let realm = try Realm()
            let results = realm.objects(Drink.self).filter("idDrink = '\(idDrink)'")
            try realm.write {
                realm.delete(results)
            }
            completion(true)
        } catch {
            completion(false)
        }
    }
    
    func deleteAllItem(completion: @escaping (Bool) -> Void) {
        do {
            let realm = try Realm()
            let results = realm.objects(Drink.self)
            try realm.write {
                realm.delete(results)
            }
            completion(true)
        } catch {
            completion(false)
        }
    }
    
    func numberOfItemsInSection() -> Int {
        return drinks.count
    }
    
    func viewModelCellForItemAt(index: Int) -> DrinkCellViewModel {
        let item = drinks[index]
        let viewModel = DrinkCellViewModel(drink: item)
        return viewModel
    }
    
    func viewModelDidSelectItemAt(index: Int) -> DetailDrinkViewModel {
        let item = drinks[index]
        let viewModel = DetailDrinkViewModel(drink: item)
        return viewModel
    }
}
