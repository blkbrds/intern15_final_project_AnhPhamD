//
//  HomeViewModel.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 6/30/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

final class HomeViewModel {

    // MARK: - Properties
    var drinks: [Drink] = []
    var tagGroups: [TagGroup] = []
    var status: MenuItem = .category

    // MARK: - Function
    func getCategories(category: String, completion: @escaping (Bool, String) -> Void) {
        Networking.shared().getCategory(category: category) { (apiResult: APIResult<TagGroupResult>) in
            switch apiResult {
            case .failure(let stringError):
                completion(false, stringError)
            case .success(let tagGroupResult):
                self.tagGroups = tagGroupResult.tagGroups
                completion(true, "Success")
            }
        }
    }

    func getDrinkForCategories(firstChar: String, keyword: String, completion: @escaping (Bool, String) -> Void) {
        Networking.shared().getDrinkForCategory(firstChar: firstChar, keyword: keyword) { (apiResult: APIResult<DrinkResult>) in
            switch apiResult {
            case .failure(let stringError):
                completion(false, stringError)
            case .success(let drinkResult):
                self.drinks = drinkResult.drinks
                completion(true, "Success")
            }
        }
    }

    func numberOfRowsInSection() -> Int {
        return drinks.count
    }

    func viewModelCellForRowAt(indexPath: Int) -> DrinkTableCellViewModel {
        let item = drinks[indexPath]
        let viewModel = DrinkTableCellViewModel(drink: item)
        return viewModel
    }
    
    func getIdOfRow(index: Int) -> DetailDrinkViewModel {
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

    func viewModelCellForItems(indexPath: Int) -> DrinkCollectionCellViewModel {
        let item = drinks[indexPath]
        let viewModel = DrinkCollectionCellViewModel(drink: item)
        return viewModel
    }
    
    func getIdOfItem(index: Int) -> DetailDrinkViewModel {
        let item = drinks[index]
        let viewModel = DetailDrinkViewModel(drinkID: item.drinkID)
        return viewModel
    }
}
