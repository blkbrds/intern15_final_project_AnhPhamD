//
//  Drink.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 6/30/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import RealmSwift

final class Drink: Object {

    // MARK: - Properties
    @objc dynamic var nameTitle: String = ""
    @objc dynamic var imageURL: String = ""
    @objc dynamic var drinkID: String = ""
    var instruction: String = ""
    var category: String = ""
    var glass: String = ""
    var alcoholic: String = ""
    var isFavorite: Bool = false
    private var ingredients: [String] = []
    private var measures: [String] = []
    var material: [String] = []

    override static func primaryKey() -> String? {
        return "drinkID"
    }

    // MARK: - Convenience Init
    convenience init(json: JSON) {
        self.init()
        if let nameTitleJS = json["strDrink"] as? String {
            self.nameTitle = nameTitleJS
        } else {
            self.nameTitle = ""
        }
        if let imageURL = json["strDrinkThumb"] as? String {
            self.imageURL = imageURL
        } else {
            self.imageURL = ""
        }
        if let drinkIDJS = json["idDrink"] as? String {
            self.drinkID = drinkIDJS
        } else {
            self.drinkID = ""
        }
        if let categoryJS = json["strCategory"] as? String {
            self.category = categoryJS
        } else {
            self.category = ""
        }
        if let glassJS = json["strGlass"] as? String {
            self.glass = glassJS
        } else {
            self.glass = ""
        }
        if let alcoholicJS = json["strAlcoholic"] as? String {
            self.alcoholic = alcoholicJS
        } else {
            self.alcoholic = ""
        }
        if let instructionJS = json["strInstructions"] as? String {
            if instructionJS != "" {
                self.instruction = instructionJS
            } else {
                self.instruction = "Empty data"
            }
        } else {
            self.instruction = ""
        }
        for index in 1...15 {
            if let ingredientJS = json["strIngredient\(index)"] as? String {
                self.ingredients.append(ingredientJS)
            }
        }
        for index in 1...15 {
            if let measureJS = json["strMeasure\(index)"] as? String {
                self.measures.append(measureJS)
            } else {
                self.measures.append("---")
            }
        }
        
        material = zip(ingredients, measures).map { (ingredient, measure) -> String in
            return ingredient + ": " + measure
        }
    }
}
