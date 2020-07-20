//
//  DetailDrinkTableViewCell.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/8/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

final class MaterialCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet private weak var materialLabel: UILabel!

    // MARK: - Properties
    var viewModel: MaterialViewModel? {
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
        materialLabel.text = viewModel.material
    }
}
