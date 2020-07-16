//
//  HomeTableViewCell.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 6/30/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

// MARK: - Protocol
protocol DrinkTableViewCellDelegate: class {
    func handleFavoriteTableView(cell: DrinkTableViewCell, idDrink: String, isFavorite: Bool)
}

final class DrinkTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var titleView: UIView!

    // MARK: - Properties
    var viewModel: DrinkCellViewModel? {
        didSet {
            updateView()
        }
    }
    weak var delegate: DrinkTableViewCellDelegate?

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.cornerRadius = 15
        titleView.layer.cornerRadius = 15
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    // MARK: - Function
    private func updateView() {
        guard let viewModel = viewModel else {
            return
        }
        nameLabel.text = viewModel.nameTitle
        favoriteButton.isSelected = viewModel.isFavorite
        avatarImageView.loadImageFromUrl(urlString: viewModel.imageURL)
    }

    // MARK: - IBAction
    @IBAction private func favoriteButtonTouchUpInSide(_ sender: Any) {
        guard let viewModel = viewModel else { return }
        if let delegate = delegate {
            delegate.handleFavoriteTableView(cell: self, idDrink: viewModel.idDrink, isFavorite: viewModel.isFavorite)
        }
        updateView()
    }
}
