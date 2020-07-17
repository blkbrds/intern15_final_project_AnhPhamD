//
//  SearchCell.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/16/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

// MARK: - Protocol
protocol SearchCellDelegate: class {
    func handleFavorite(_ cell: SearchCell, idDrink: String, isFavorite: Bool)
}

final class SearchCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameTitleLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var titleView: UIView!

    // MARK: - Properties
    var viewModel: SearchCellViewModel? {
        didSet {
            updateView()
        }
    }
    weak var delegate: SearchCellDelegate?

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.cornerRadius = 15
        titleView.layer.cornerRadius = 15
    }

    // MARK: - Function
    private func updateView() {
        guard let viewModel = viewModel else { return }
        nameTitleLabel.text = viewModel.nameTitle
        avatarImageView.loadImageFromUrl(urlString: viewModel.imageURL)
        favoriteButton.isSelected = viewModel.isFavorite
    }

    // MARK: - @IBAction
    @IBAction private func favoriteButtonTouchUpInSide(_ sender: Any) {
        guard let viewModel = viewModel else { return }
        if let delegate = delegate {
            delegate.handleFavorite(self, idDrink: viewModel.drinkID, isFavorite: viewModel.isFavorite)
        }
        updateView()
    }
}
