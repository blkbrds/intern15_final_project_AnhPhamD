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
    
    func dummyData() {
        drinks.append(Drink(name: "Tuan"))
        drinks.append(Drink(name: "Anh"))
        drinks.append(Drink(name: "Quan Baby"))
        drinks.append(Drink(name: "To Co To Co"))
        drinks.append(Drink(name: "Ton That Tung"))
    }
    
    func numberOfRowsInSection() -> Int {
        return drinks.count
    }
    
    func viewModelCellForRowAt(indexPath: Int) -> HomeCellViewModel {
        let item = drinks[indexPath]
        let viewModel = HomeCellViewModel(drink: item)
        return viewModel
    }
}
