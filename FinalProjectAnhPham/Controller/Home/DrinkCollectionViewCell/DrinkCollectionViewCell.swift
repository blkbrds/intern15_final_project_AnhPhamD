//
//  DrinkCollectionViewCell.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 6/30/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

// MARK: - Protocol
protocol DrinkCollectionViewCellDelegate: class {
    func dowloadImage(cell: DrinkCollectionViewCell, indexPath: IndexPath)
}

final class DrinkCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlet
    @IBOutlet private weak var nameDrinkLabel: UILabel!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var favoriteButton: UIButton!

    // MARK: - Properties
    var viewModel: DrinkCollectionCellViewModel? {
        didSet {
            updateView()
        }
    }

    weak var delegate: DrinkCollectionViewCellDelegate?
    var indexPath: IndexPath?

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Function
    private func updateView() {
        guard let viewModel = viewModel else { return }
        nameDrinkLabel.text = viewModel.name
        favoriteButton.isSelected = viewModel.isFavorite
        if viewModel.thumbnailImage == nil {
            if let delegate = delegate {
                if let indexPath = indexPath {
                    delegate.dowloadImage(cell: self, indexPath: indexPath)
                }
            }
        } else {
            avatarImageView.image = viewModel.thumbnailImage
        }
    }

    // MARK: - IBAction
    @IBAction private func favoriteButtonTouchUpInSide(_ sender: Any) {
        guard let viewModel = viewModel else { return }
        favoriteButton.isSelected = !viewModel.isFavorite
        viewModel.isFavorite = !viewModel.isFavorite
    }
}
