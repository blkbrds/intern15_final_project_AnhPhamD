//
//  SideMenuViewModel.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/4/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation

// MARK: - Enum
enum MenuItem: String {
    case category = "Category"
    case glass = "Glass"
    case alcoholic = "Alcoholic"
    case favorite = "Favorite"
    case search = "Search"

    var icon: String {
        switch self {
        case .category: return "ic-category"
        case .glass: return "ic-glass"
        case .alcoholic: return "ic-alcoholic"
        case .favorite: return "ic-favorite"
        case .search: return "ic-search"
        }
    }
}

final class SideMenuViewModel {

    // MARK: - Properties
    private var menus: [MenuItem] = [.category, .glass, .alcoholic, .favorite, .search]

    // MARK: - Function
    func numberOfRowsInSection() -> Int {
        return menus.count
    }

    func viewModelCellForRowAt(index: Int) -> SideMenuCellViewModel {
        let item = menus[index]
        let viewModel = SideMenuCellViewModel(menuItem: item)
        return viewModel
    }

    func getMenuItem(at index: Int) -> MenuItem? {
        guard index < menus.count else { return nil }
        return menus[index]
    }
}
