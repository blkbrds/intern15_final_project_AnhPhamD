//
//  OtherDrinkViewModel.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/20/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation

final class OtherDrinkViewModel {

    // MARK: - Properties
    var otherDrinks: [Drink]

    // MARK: - Init
    init(otherDrinks: [Drink] = []) {
        self.otherDrinks = otherDrinks
    }

    // MARK: - Function
    func numberOfItemsInSection() -> Int {
        return otherDrinks.count
    }

    func viewModelCellForItemAt(index: Int) -> OtherDrinkCollectionCellViewModel {
        let item = otherDrinks[index]
        let viewModel = OtherDrinkCollectionCellViewModel(drink: item)
        return viewModel
    }
}
