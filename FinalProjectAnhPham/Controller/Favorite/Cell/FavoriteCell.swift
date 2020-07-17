//
//  FavoriteCell.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/15/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

// MARK: - Protocol
protocol FavoriteCellDelegate: class {
    func handleFavorite(cell: FavoriteCell, drinkID: String, isFavorite: Bool)
}

class FavoriteCell: UICollectionViewCell {

    // MARK: - IBOutlet
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var nameTitleLabel: UILabel!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var titleView: UIView!
    
    // MARK: - Properties
    weak var delegate: FavoriteCellDelegate?
    var viewModel: FavoriteCellViewModel? {
        didSet {
            updateView()
        }
    }
    
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
    }
    
    @IBAction func deleteButtonTouchUpInSide(_ sender: Any) {
        guard let viewModel = viewModel else { return }
        if let delegate = delegate {
            delegate.handleFavorite(cell: self, drinkID: viewModel.drinkID, isFavorite: viewModel.isFavorite)
        }
        updateView()
    }
}
