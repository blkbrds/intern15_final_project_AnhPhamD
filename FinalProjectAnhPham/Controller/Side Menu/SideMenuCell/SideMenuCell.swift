//
//  SideMenuCell.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/4/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

final class SideMenuCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!

    // MARK: - Properties
    var viewModel: SideMenuCellViewModel? {
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
        titleLabel.text = viewModel.title
        iconImageView.image = UIImage(named: viewModel.icon)
    }
}
