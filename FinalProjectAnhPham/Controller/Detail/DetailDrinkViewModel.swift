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
    var idDrink: String
    var drink: Drink?
    var sections: [SectionType] = [.instruction, .ingredient, .measure]
    
    // MARK: - Init
    init(drink: Drink) {
        self.idDrink = drink.idDrink
    }
    
    // MARK: - Function
    func getDetailDrink(completion: @escaping (Bool, String) -> Void) {
        Networking.shared().getDetailDrink(id: idDrink) { [weak self] (apiResult: APIResult<DrinkResult>) in
            guard let this = self else { return }
            switch apiResult {
            case .failure(let stringError):
                completion(false, stringError)
            case .success(let data):
                this.drink = data.drinks.first
                completion(true, "Success")
            }
        }
    }
    
    func checkFavorite(completion: @escaping (Bool) -> Void) {
        do {
            let realm = try Realm()
            let results = realm.objects(Drink.self).filter("idDrink = '\(idDrink)'")
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
            let result = realm.objects(Drink.self).filter("idDrink = '\(idDrink)'")
            try realm.write {
                realm.delete(result)
            }
        } catch {
            print(error)
        }
    }
    
    func addFavorite(idDrink: String, nameTitle: String, imageUrl: String) {
        do {
            let realm = try Realm()
            let drink = Drink()
            drink.idDrink = idDrink
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
