//
//  HomeTableViewCell.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 6/30/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

final class DrinkTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var titleView: UIView!

    // MARK: - Properties
    var viewModel: DrinkTableCellViewModel? {
        didSet {
            updateView()
        }
    }
    var indexPath: IndexPath?

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
        guard let viewModel = viewModel else {
            return
        }
        nameLabel.text = viewModel.name
        favoriteButton.isSelected = viewModel.isFavorite
        avatarImageView.loadImageFromUrl(urlString: viewModel.imageURL)
    }

    // MARK: - IBAction
    @IBAction private func favoriteButtonTouchUpInSide(_ sender: Any) {
        guard let viewModel = viewModel else { return }
        favoriteButton.isSelected = !viewModel.isFavorite
        viewModel.isFavorite = !viewModel.isFavorite
    }
}
