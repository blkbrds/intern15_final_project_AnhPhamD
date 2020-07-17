//
//  HomeViewModel.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 6/30/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import RealmSwift

final class HomeViewModel {

    // MARK: - Properties
    var drinks: [Drink] = []
    var tagGroups: [TagGroup] = []
    var status: MenuItem = .category
    var realmDrinks: [Drink] = []
    var isFavorite: Bool = false

    // MARK: - Function
    
    func fetchRealmData() {
        do {
            // Realm
            let realm = try Realm()
            // Create results
            let results = realm.objects(Drink.self)
            // Convert to array
            realmDrinks = Array(results)
        } catch {
            print(error)
        }
    }
    
    func addFavorite(drinkID: String, nameTitle: String, imageUrl: String) {
        do {
            let realm = try Realm()
            let drink = Drink()
            drink.drinkID = drinkID
            drink.nameTitle = nameTitle
            drink.imageURL = imageUrl
            try realm.write {
                realm.add(drink, update: .all)
                editFavorite(favorite: true, drinkID: drinkID)
            }
        } catch {
            print(error)
        }
    }
    
    func deleteItemFavorite(drinkID: String) {
        do {
            let realm = try Realm()
            let result = realm.objects(Drink.self).filter("drinkID = '\(drinkID)'")
            try realm.write {
                realm.delete(result)
                editFavorite(favorite: false, drinkID: drinkID)
            }
        } catch {
            print(error)
        }
    }
    
    func editFavorite(favorite: Bool, drinkID: String) {
        for item in drinks where item.drinkID == drinkID {
            item.isFavorite = favorite
        }
    }
    
    func getCategories(category: String, completion: @escaping (Bool, String) -> Void) {
        Networking.shared().getCategory(category: category) { [weak self] (apiResult: APIResult<TagGroupResult>) in
            guard let this = self else { return }
            switch apiResult {
            case .failure(let stringError):
                completion(false, stringError)
            case .success(let tagGroupResult):
                this.tagGroups = tagGroupResult.tagGroups
                completion(true, "Success")
            }
        }
    }

    func getDrinkForCategories(firstChar: String, keyword: String, completion: @escaping (Bool, String) -> Void) {
        Networking.shared().getDrinkForCategory(firstChar: firstChar, keyword: keyword) { [weak self] (apiResult: APIResult<DrinkResult>) in
            guard let this = self else { return }
            switch apiResult {
            case .failure(let stringError):
                completion(false, stringError)
            case .success(let drinkResult):
                this.drinks = drinkResult.drinks
                for i in 0..<this.drinks.count {
                    this.drinks[i].isFavorite = this.realmDrinks.contains(where: { $0.drinkID == this.drinks[i].drinkID })
                }
                completion(true, "Success")
            }
        }
    }

    func numberOfRowsInSection() -> Int {
        return drinks.count
    }

    func viewModelCellForRowAt(indexPath: Int) -> DrinkCellViewModel {
        let item = drinks[indexPath]
        let viewModel = DrinkCellViewModel(drink: item)
        return viewModel
    }
    
    func viewModelDidSelectRowAt(index: Int) -> DetailDrinkViewModel {
        let item = drinks[index]
        let viewModel = DetailDrinkViewModel(drinkID: item.drinkID)
        return viewModel
    }

    func numberOfTagsInSection() -> Int {
        return tagGroups.count
    }

    func viewModelCellForTags(indexPath: Int) -> TagCellViewModel {
        let item = tagGroups[indexPath]
        let viewModel = TagCellViewModel(tagGroup: item)
        return viewModel
    }

    func numberOfItemsInSection() -> Int {
        return drinks.count
    }

    func viewModelCellForItems(indexPath: Int) -> DrinkCellViewModel {
        let item = drinks[indexPath]
        let viewModel = DrinkCellViewModel(drink: item)
        return viewModel
    }
    
    func viewModelDidSelectItemAt(index: Int) -> DetailDrinkViewModel {
        let item = drinks[index]
        let viewModel = DetailDrinkViewModel(drinkID: item.drinkID)
        return viewModel
    }
}
