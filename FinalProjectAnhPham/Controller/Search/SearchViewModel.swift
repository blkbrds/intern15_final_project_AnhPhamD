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
                    self.drinks[i].isFavorite = self.realmDrinks.contains(where: { $0.idDrink == self.drinks[i].idDrink })
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

    func addFavorite(idDrink: String, nameTitle: String, imageUrl: String) {
        do {
            let realm = try Realm()
            let drink = Drink()
            drink.idDrink = idDrink
            drink.nameTitle = nameTitle
            drink.imageURL = imageUrl
            try realm.write {
                realm.add(drink, update: .all)
                checkFavorite(favorite: true, idDrink: idDrink)
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
                checkFavorite(favorite: false, idDrink: idDrink)
            }
        } catch {
            print(error)
        }
    }

    func checkFavorite(favorite: Bool, idDrink: String) {
        for item in drinks where item.idDrink == idDrink {
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
        let viewModel = DetailDrinkViewModel(drink: item)
        return viewModel
    }
}
