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

// MARK: - DetailDrinkViewModel
extension DetailDrinkViewModel {
    enum SectionType: String {
        case instruction = "Instruction"
        case material = "Material"
    }
}
