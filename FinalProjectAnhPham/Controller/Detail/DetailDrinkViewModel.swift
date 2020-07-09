//
//  DetailViewModel.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/8/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation

final class DetailDrinkViewModel {

    // MARK: - Properties
    var idDrink: String
    var drink: Drink?
    var sections: [SectionType] = [.instruction, .ingredient, .measure]

    // MARK: - Init
    init(drink: Drink) {
        self.idDrink = drink.idDrink
    }

    // MARK: - Function
    func getDetailDrink(completion: @escaping (Bool, String) -> Void) {
        Networking.shared().getDetailDrink(id: idDrink) { (apiResult: APIResult<DrinkResult>) in
            switch apiResult {
            case .failure(let stringError):
                completion(false, stringError)
            case .success(let data):
                self.drink = data.drinks.first
                completion(true, "Success")
            }
        }
    }

    func numberOfSections() -> Int {
        return sections.count
    }

    func numberOfRowsInSection(section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 1
        }
    }

    func titleHeaderInSection(section: Int) -> String? {
        return sections[section].rawValue
    }
}

// MARK: - DetailDrinkViewModel
extension DetailDrinkViewModel {
    enum SectionType: String {
        case instruction = "Instruction"
        case ingredient = "Ingredient"
        case measure = "Measure"
    }
}
