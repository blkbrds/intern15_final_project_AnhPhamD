//
//  IngredientTableViewCell.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/8/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

final class IngredientTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var ingredientLabel: UILabel!

    // MARK: - Properties
    var viewModel: DetailCellViewModel? {
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
        guard let viewModel = viewModel else {
            return
        }
        ingredientLabel.text = viewModel.label
    }
}
