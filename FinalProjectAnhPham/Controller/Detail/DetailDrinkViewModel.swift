//
//  DetailViewModel.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/8/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import RealmSwift

final class DetailDrinkViewModel {

    // MARK: - Properties
    var status = Favorite.favorite
    var drinkID: String
    var drink: Drink?
    var otherDrinks: [Drink] = []
    var materials: [String] = []
    var sections: [SectionType] = [.instruction, .material, .other]

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
            case .success(let drinkDetail):
                self.drink = drinkDetail.drink
                if let drink = drinkDetail.drink {
                    self.materials = drink.materials
                }
                completion(true, "Success")
            }
        }
    }

    func getOtherDrink(firstChar: String, keyword: String, completion: @escaping (Bool, String) -> Void) {
        Networking.shared().getDrinkForCategory(firstChar: firstChar, keyword: keyword) { (apiResult: APIResult<DrinkResult>) in
            switch apiResult {
            case .failure(let stringError):
                completion(false, stringError)
            case .success(let drinkResult):
                self.otherDrinks = drinkResult.drinks
                completion(true, "Success")
            }
        }
    }

    func checkFavorite(completion: @escaping (Bool) -> Void) {
        do {
            let realm = try Realm()
            let results = realm.objects(Drink.self).filter("drinkID = '\(drinkID)'")
            if results.isEmpty {
                completion(false)
            } else {
                completion(true)
            }
        } catch {
            print(error)
        }
    }

    func deleteItemFavorite() {
        do {
            let realm = try Realm()
            let result = realm.objects(Drink.self).filter("drinkID = '\(drinkID)'")
            try realm.write {
                realm.delete(result)
            }
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
                realm.add(drink)
            }
        } catch {
            print(error)
        }
    }

    func numberOfSections() -> Int {
        return sections.count
    }

    func numberOfRowsInSection(section: Int) -> Int {
        guard section < sections.count else { return 0 }
        switch sections[section] {
        case .instruction:
            return 1
        case .material:
            return materials.count
        case .other:
            return 1
        }
    }

    func viewModelCellForRowAt(index: Int) -> InstructionViewModel {
        let item = drink?.instruction
        let viewModel = InstructionViewModel(instruction: item ?? "")
        return viewModel
    }

    func viewModelCellForRowAt2(index: Int) -> MaterialViewModel {
        let item = materials[index]
        let viewModel = MaterialViewModel(material: item)
        return viewModel
    }

    func viewModelCellForRowAt3() -> OtherDrinkViewModel {
        let item = otherDrinks
        let viewModel = OtherDrinkViewModel(otherDrinks: item)
        return viewModel
    }
    
    func viewModelDidSelectItemAt(index: Int) -> DetailDrinkViewModel {
        let item = otherDrinks[index]
        let viewModel = DetailDrinkViewModel(drinkID: item.drinkID)
        return viewModel
    }
    
    func titleHeaderInSection(section: Int) -> String? {
        return sections[section].rawValue
    }
}

// MARK: - DetailDrinkViewModel
extension DetailDrinkViewModel {
    enum SectionType: String {
        case instruction = "Instruction"
        case material = "Material"
        case other = "Other Drink"
    }
}
