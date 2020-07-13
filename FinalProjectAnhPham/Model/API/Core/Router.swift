//
//  Router.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/2/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation

final class API {
    
    static var baseURL: String = "https://www.thecocktaildb.com/api/json/v1/1/"
    struct Home {
        static var categories = baseURL + "list.php?"
        static var filterCategories = baseURL + "filter.php?"
        static var detailCategories = baseURL + "lookup.php?"
    }
}
