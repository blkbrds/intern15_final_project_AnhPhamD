//
//  HomeViewModel.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 6/30/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - Protocol
protocol HomeViewModelDelegate: class {
    func syncFavorite(viewModel: HomeViewModel, needperformAction action: HomeViewModel.Action)
}

final class HomeViewModel {

    // MARK: - Enum
    enum Action {
        case reloadData
    }
    
    // MARK: - Properties
    var drinks: [Drink] = []
    var drinksLoadMore: [Drink] = []
    var page: Int = 20
    var tagGroups: [TagGroup] = []
    var status: MenuItem = .category
    var realmDrinks: [Drink] = []
    private var notificationToken: NotificationToken?
    weak var delegate: HomeViewModelDelegate?

    // MARK: - Function
    func setupObserve() {
        do {
            let realm = try Realm()
            notificationToken = realm.objects(Drink.self).observe({ [weak self] _ in
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
                this.drinksLoadMore = Array(this.drinks.prefix(10))
                for i in 0..<this.drinks.count {
                    this.drinks[i].isFavorite = this.realmDrinks.contains(where: { $0.drinkID == this.drinks[i].drinkID })
                }
                completion(true, "Success")
            }
        }
    }

    func numberOfRowsInSection() -> Int {
        return drinksLoadMore.count
    }

    func viewModelCellForRowAt(indexPath: Int) -> DrinkCellViewModel {
        let item = drinksLoadMore[indexPath]
        let viewModel = DrinkCellViewModel(drink: item)
        return viewModel
    }
    
    func viewModelDidSelectRowAt(index: Int) -> DetailDrinkViewModel {
        let item = drinksLoadMore[index]
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
        return drinksLoadMore.count
    }

    func viewModelCellForItems(indexPath: Int) -> DrinkCellViewModel {
        let item = drinksLoadMore[indexPath]
        let viewModel = DrinkCellViewModel(drink: item)
        return viewModel
    }
    
    func viewModelDidSelectItemAt(index: Int) -> DetailDrinkViewModel {
        let item = drinksLoadMore[index]
        let viewModel = DetailDrinkViewModel(drinkID: item.drinkID)
        return viewModel
    }
    
    func clearData() {
        drinks.removeAll()
    }
}
