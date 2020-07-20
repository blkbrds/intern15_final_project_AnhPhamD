//
//  OtherDrinkCollectionCell.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/20/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

class OtherDrinkCollectionCell: UICollectionViewCell {

    // MARK: - IBOutlet
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameTitleLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var titleView: UIView!

    // MARK: - Properties
    var viewModel: OtherDrinkCollectionCellViewModel? {
        didSet {
            updateView()
        }
    }

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.cornerRadius = 15
        titleView.layer.cornerRadius = 15
        // Initialization code
    }

    // MARK: - Function
    private func updateView() {
        guard let viewModel = viewModel else { return }
        avatarImageView.loadImageFromUrl(urlString: viewModel.imageURL)
        nameTitleLabel.text = viewModel.nameTitle
        favoriteButton.isSelected = viewModel.isFavorite
    }
}
