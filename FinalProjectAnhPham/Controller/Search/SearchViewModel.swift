//
//  SearchViewModel.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/16/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import RealmSwift

final class SearchViewModel {

    // MARK: - Properties
    var status: MenuItem
    var drinks: [Drink] = []
    var realmDrinks: [Drink] = []

    // MARK: - Init
    init(status: MenuItem = .category) {
        self.status = status
    }

    // MARK: - Function
    func getResultSearchByName(keywork: String, completion: @escaping (Bool, String) -> Void) {
        Networking.shared().getResultSearchByName(keywork: keywork) { (apiResult: APIResult<DrinkResult>) in
            switch apiResult {
            case .failure(let stringError):
                completion(false, stringError)
            case .success(let drinkResults):
                self.drinks = drinkResults.drinks
                for i in 0..<self.drinks.count {
                    self.drinks[i].isFavorite = self.realmDrinks.contains(where: { $0.drinkID == self.drinks[i].drinkID })
                }
                completion(true, "Success")
            }
        }
    }

    func fetchRealmData() {
        do {
            let realm = try Realm()
            let results = realm.objects(Drink.self)
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
                checkFavorite(favorite: true, drinkID: drinkID)
            }
        } catch {
            print(error)
        }
    }

    func deleteItemFavorite(idDrink: String) {
        do {
            let realm = try Realm()
            let result = realm.objects(Drink.self).filter("idDrink = '\(idDrink)'")
            try realm.write {
                realm.delete(result)
                checkFavorite(favorite: false, drinkID: idDrink)
            }
        } catch {
            print(error)
        }
    }

    func checkFavorite(favorite: Bool, drinkID: String) {
        for item in drinks where item.drinkID == drinkID {
            item.isFavorite = favorite
        }
    }

    func numberOfRowsInSection() -> Int {
        return drinks.count
    }

    func viewModelCellForRowAt(index: Int) -> SearchCellViewModel {
        let item = drinks[index]
        let viewModel = SearchCellViewModel(drink: item)
        return viewModel
    }

    func viewModelDidSelectRowAt(index: Int) -> DetailDrinkViewModel {
        let item = drinks[index]
        let viewModel = DetailDrinkViewModel(drinkID: item.drinkID)
        return viewModel
    }
}
