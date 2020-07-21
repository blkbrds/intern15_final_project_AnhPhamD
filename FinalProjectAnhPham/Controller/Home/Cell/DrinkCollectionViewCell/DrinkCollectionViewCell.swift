//
//  DrinkCollectionViewCell.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 6/30/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

protocol DrinkCollectionViewCellDelegate: class {
    func handleFavoriteCollection(cell: DrinkCollectionViewCell, drinkID: String, isFavorite: Bool)
}

final class DrinkCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlet
    @IBOutlet private weak var nameDrinkLabel: UILabel!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var titleView: UIView!

    // MARK: - Properties
    var viewModel: DrinkCellViewModel? {
        didSet {
            updateView()
        }
    }
    weak var delegate: DrinkCollectionViewCellDelegate?

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.cornerRadius = 15
        titleView.layer.cornerRadius = 15
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
    }

    // MARK: - Function
    private func updateView() {
        guard let viewModel = viewModel else { return }
        nameDrinkLabel.text = viewModel.nameTitle
        favoriteButton.isSelected = viewModel.isFavorite
        avatarImageView.loadImageFromUrl(urlString: viewModel.imageURL)
    }

    // MARK: - IBAction
    @IBAction private func favoriteButtonTouchUpInSide(_ sender: Any) {
        guard let viewModel = viewModel else { return }
        if let delegate = delegate {
            delegate.handleFavoriteCollection(cell: self, drinkID: viewModel.drinkID, isFavorite: viewModel.isFavorite)
        }
        updateView()
    }
}
