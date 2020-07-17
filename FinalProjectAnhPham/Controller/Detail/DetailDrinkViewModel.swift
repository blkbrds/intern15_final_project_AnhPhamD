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
    var drinkID: String
    var drink: Drink?
    var ingredients: [String] = []
    var measures: [String] = []
    var sections: [SectionType] = [.instruction, .ingredient]

    // MARK: - Init
    init(drinkID: String) {
        self.drinkID = drinkID
    }

    // MARK: - Function
    func getDetailDrink(completion: @escaping (Bool, String) -> Void) {
        Networking.shared().getDetailDrink(drinkID: drinkID) { (apiResult: APIResult<DrinkDetail>) in
            switch apiResult {
            case .failure(let stringError):
                completion(false, stringError)
            case .success(let drinkResult):
                self.drink = drinkResult.drink
                if let ingredients = self.drink?.ingredients, let measures = self.drink?.measures {
                    self.ingredients = ingredients
                    self.measures = measures
                    self.checkDataDetail()
                }
                completion(true, "Success")
            }
        }
    }
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        switch sections[section] {
        case .instruction:
            return 1
        default:
            return ingredients.count
        }
    }
    
    func viewModelCellForRowAt2(index: Int) -> InformationViewModel {
        let item = ingredients[index]
        let item1 = measures[index]
        let viewModel = InformationViewModel(ingredient: item, measure: item1)
        return viewModel
    }
    
    func viewModelCellForRowAt(index: Int) -> InstructionViewModel {
        let item = drink?.instruction
        let viewModel = InstructionViewModel(instruction: item ?? "")
        return viewModel
    }
    
    func titleHeaderInSection(section: Int) -> String? {
        return sections[section].rawValue
    }
    
    func checkDataDetail() {
        if ingredients.count != measures.count {
            if ingredients.count > measures.count {
                let count = ingredients.count - measures.count
                for _ in 0 ... count {
                    measures.append("Empty Data")
                }
            } else {
                let count = measures.count - ingredients.count
                for _ in 0 ... count {
                    ingredients.append("Empty Data")
                }

            }
        }
    }
}

extension DetailDrinkViewModel {
    enum SectionType: String {
        case instruction = "Instruction"
        case ingredient = "Ingredient"
    }
}
