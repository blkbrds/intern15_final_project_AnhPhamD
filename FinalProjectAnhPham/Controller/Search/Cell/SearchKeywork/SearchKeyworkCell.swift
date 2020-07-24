//
//  SearchKeyworkCell.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/21/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

class SearchKeyworkCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet private weak var searchKeyLabel: UILabel!

    // MARK: - Properties
    var viewModel: SearchKeyworkViewModel? {
        didSet {
            updateView()
        }
    }

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK: - Function
    private func updateView() {
        guard let viewModel = viewModel else { return }
        searchKeyLabel.text = viewModel.searchKey
    }
}
