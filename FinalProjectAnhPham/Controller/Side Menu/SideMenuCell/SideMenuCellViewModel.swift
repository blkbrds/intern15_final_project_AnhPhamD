//
//  SideMenuCellViewModel.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/4/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation

final class SideMenuCellViewModel {

    // MARK: - Properties
    var title: String
    var icon: String

    // MARK: - Init
    init(menuItem: MenuItem) {
        self.title = menuItem.rawValue
        self.icon = menuItem.icon
    }
}
