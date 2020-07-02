//
//  HomeTableViewCell.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 6/30/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

protocol DrinkTableViewCellDelegate: class {
    func dowloadImage(cell: DrinkTableViewCell, indexPath: IndexPath)
}

final class DrinkTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    // MARK: - Properties
    var viewModel: DrinkTableCellViewModel? {
        didSet {
            updateView()
        }
    }
    weak var delegate: DrinkTableViewCellDelegate?
    var indexPath: IndexPath?
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Function
    private func updateView() {
        guard let viewModel = viewModel else {
            return
        }
        nameLabel.text = viewModel.name
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
    @IBAction func favoriteButtonTouchUpInSide(_ sender: Any) {
        guard let viewModel = viewModel else {
            return
        }
        favoriteButton.isSelected = !viewModel.isFavorite
        viewModel.isFavorite = !viewModel.isFavorite
    }
}
