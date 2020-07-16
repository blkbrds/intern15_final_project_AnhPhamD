//
//  InformationViewModel.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/16/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation

final class InformationViewModel {
    var ingredient: String
    var measure: String
    
    init(ingredient: String, measure: String) {
        self.ingredient = ingredient
        self.measure = measure
    }
}
