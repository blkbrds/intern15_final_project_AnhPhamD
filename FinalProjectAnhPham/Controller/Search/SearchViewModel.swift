//
//  SearchViewModel.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/16/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - Protocol
protocol SearchViewModelDelegate: class {
    func syncFavorite(viewModel: SearchViewModel, needperformAction action: SearchViewModel.Action)
}

final class SearchViewModel {
    
    // MARK: - Enum
    enum Action {
        case reloadData
    }

    // MARK: - Properties
    var status: MenuItem
    var drinks: [Drink] = []
    var realmDrinks: [Drink] = []
    var searchResults: [SearchHistory] = []
    private var notificationToken: NotificationToken?
    weak var delegate: SearchViewModelDelegate?

    // MARK: - Init
    init(status: MenuItem = .category) {
        self.status = status
        setupObserve()
    }

    // MARK: - Function
    func setupObserve() {
        do {
            let realm = try Realm()
            notificationToken = realm.objects(Drink.self).observe({ [weak self] (change) in
                guard let this = self else { return }
                if let delegate = this.delegate {
                    this.fetchRealmData()
                    for i in 0..<this.drinks.count {
                        this.drinks[i].isFavorite = this.realmDrinks.contains(where: { $0.drinkID == this.drinks[i].drinkID })
                    }
                    delegate.syncFavorite(viewModel: this, needperformAction: .reloadData)
                }
            })
        } catch {
            print(error)
        }
    }
    
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
    
    func fetchSearchHistoryData(completion: @escaping (Bool, String) -> Void) {
        do {
            let realm = try Realm()
            let results = realm.objects(SearchHistory.self)
            var search = Array(results)
            search.reverse()
            searchResults = Array(search.prefix(5))
            completion(true, "Success")
        } catch {
            completion(false, "Fetch realm error")
        }
    }
    
    func addSearchHistory(searchKey: String, completion: @escaping (Bool) -> Void) {
        do {
            let realm = try Realm()
            let result = SearchHistory()
            result.searchKey = searchKey
            try realm.write {
                realm.add(result)
            }
            completion(true)
        } catch {
            completion(false)
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
    
    func numberOfRowsInSectionHistory() -> Int {
        return searchResults.count
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
    
    func viewModelSearchKeyOfRowInSection() -> Int {
        return searchResults.count
    }
    
    func viewModelSearchKeyCellForRowAt(index: Int) -> SearchKeyworkViewModel {
        let item = searchResults[index]
        let viewModel = SearchKeyworkViewModel(searchHistory: item)
        return viewModel
    }
}
