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
    var materials: [String] {
        guard let drink = drink else { return [] }
        return drink.material
    }
    var sections: [SectionType] = [.instruction, .material]

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
            return materials.count
        }
    }
    
    func viewModelCellForRowAt2(index: Int) -> MaterialViewModel {
        let item = materials[index]
        let viewModel = MaterialViewModel(material: item)
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
}

extension DetailDrinkViewModel {
    enum SectionType: String {
        case instruction = "Instruction"
        case material = "Material"
    }
}
