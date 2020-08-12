//
//  FavoriteViewModel.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/13/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - Protocol
protocol FavoriteViewModelDelegate: class {
    func syncFavorite(viewModel: FavoriteViewModel, needperformAction action: FavoriteViewModel.Action)
}

final class FavoriteViewModel {
    
    // MARK: - Enum
    enum Action {
        case reloadData
    }

    // MARK: - Properties
    var status: MenuItem
    var drinks: [Drink] = []
    var isFavorite: Bool = false
    private var notificationToken: NotificationToken?
    weak var delegate: FavoriteViewModelDelegate?
    
    // MARK: - Init
    init(status: MenuItem = .category) {
        self.status = status
        setupObserve()
    }

    // MARK: - Function
    private func setupObserve() {
        do {
            let realm = try Realm()
            notificationToken = realm.objects(Drink.self).observe({ (_) in
                if let delegate = self.delegate {
                    delegate.syncFavorite(viewModel: self, needperformAction: .reloadData)
                }
            })
        } catch {
            print(error)
        }
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
    
    func deleteItemFavorite(drinkID: String, completion: @escaping (Bool) -> Void) {
        do {
            let realm = try Realm()
            let results = realm.objects(Drink.self).filter("drinkID = '\(drinkID)'")
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

    func viewModelCellForItemAt(index: Int) -> FavoriteCellViewModel {
        let item = drinks[index]
        let viewModel = FavoriteCellViewModel(drink: item)
        return viewModel
    }

    func viewModelDidSelectItemAt(index: Int) -> DetailDrinkViewModel {
        let item = drinks[index]
        let viewModel = DetailDrinkViewModel(drinkID: item.drinkID)
        return viewModel
    }
}
