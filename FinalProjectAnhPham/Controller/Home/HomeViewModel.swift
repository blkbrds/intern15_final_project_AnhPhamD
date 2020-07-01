//
//  HomeViewModel.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 6/30/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation

final class HomeViewModel {
    var drinks: [Drink] = []
    var tagGroups: [TagGroup] = []
    
    func dummyData() {
        drinks.append(Drink(name: "Tuan"))
        drinks.append(Drink(name: "Anh"))
        drinks.append(Drink(name: "Quan Baby"))
        drinks.append(Drink(name: "To Co To Co"))
        drinks.append(Drink(name: "Ton That Tung"))
        drinks.append(Drink(name: "abcbabacbcbcababac"))
        drinks.append(Drink(name: "hahahahaahahaa"))
        drinks.append(Drink(name: "hahacgdbcahsdsakdblasdasdjlhasjnadsknasdndasasasdasd"))
        tagGroups.append(TagGroup(tagName: "AnhDuc"))
        tagGroups.append(TagGroup(tagName: "TanHieuHieu"))
        tagGroups.append(TagGroup(tagName: "Abcabcdabzxzzxcxzcxzd"))
        tagGroups.append(TagGroup(tagName: "Ahdhddhdhdhdd"))
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
