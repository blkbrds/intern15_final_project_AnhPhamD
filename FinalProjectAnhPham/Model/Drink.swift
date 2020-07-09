//
//  Drink.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 6/30/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation

final class Drink {
    
    // MARK: - Properties
    var nameTitle: String
    var isFavorite: Bool
    var imageURL: String
    var idDrink: String
    var instruction: String
    var ingredient: String
    var measure: String
    var category: String
    var glass: String
    var alcoholic: String
    
    // MARK: - Init
    init(json: JSON, isFavorite: Bool = false) {
        if let nameTitleJS = json["strDrink"] as? String {
            self.nameTitle = nameTitleJS
        } else {
            self.nameTitle = ""
        }
        self.isFavorite = isFavorite
        if let imageURL = json["strDrinkThumb"] as? String {
            self.imageURL = imageURL
        } else {
            self.imageURL = ""
        }
        if let idDrinkJS = json["idDrink"] as? String {
            self.idDrink = idDrinkJS
        } else {
            self.idDrink = ""
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
        var strIngredient: String = ""
        for index in 1...15 {
            if let ingredientJS = json["strIngredient\(index)"] as? String {
                if ingredientJS != "" {
                    strIngredient += ingredientJS + "\n"
                }
            }
        }
        if strIngredient == "" {
            strIngredient = "Empty data"
        }
        self.ingredient = strIngredient
        var strMeasure: String = ""
        for index in 1...15 {
            if let measureJS = json["strMeasure\(index)"] as? String {
                if measureJS != "" {
                    strMeasure += measureJS + "\n"
                }
            }
        }
        if strMeasure == "" {
            strMeasure = "Empty data"
        }
        self.measure = strMeasure
    }
}
