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

    // MARK: - Function
    func getCategories(category: String, completion: @escaping (Bool, String) -> Void) {
        let urlString = API.Home.categories + category + "=list"
        Networking.shared().getCategory(urlString: urlString) { (apiResult: APIResult<TagGroupResult>) in
            switch apiResult {
            case .failure(let stringError):
                completion(false, stringError)
            case .success(let tagGroupResult):
                self.tagGroups = tagGroupResult.tagGroups
                completion(true, "Success")
            }
        }
    }

    func getDrinkForCategories(keyword: String, completion: @escaping (Bool, String) -> Void) {
        let urlString = API.Home.filterCategories + "c=" + keyword
        Networking.shared().getDrinkForCategory(urlString: urlString) { (apiResult: APIResult<DrinkResult>) in
            switch apiResult {
            case .failure(let stringError):
                completion(false, stringError)
            case .success(let drinkResult):
                self.drinks = drinkResult.drinks
                completion(true, "Success")
            }
        }
    }

    func getDrinkImageForCategories(at indexPath: IndexPath, completion: @escaping (IndexPath, UIImage?) -> Void) {
        let item = drinks[indexPath.row]
        if item.thumbnailImage == nil {
            Networking.shared().getDrinkImageForCategories(urlString: item.imageName) { (image) in
                if let image = image {
                    item.thumbnailImage = image
                    completion(indexPath, image)
                } else {
                    completion(indexPath, nil)
                }
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
}
