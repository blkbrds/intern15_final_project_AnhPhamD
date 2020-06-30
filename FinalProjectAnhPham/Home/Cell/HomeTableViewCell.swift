//
//  HomeTableViewCell.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 6/30/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

final class HomeTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    // MARK: - Properties
    var viewModel: HomeCellViewModel? {
        didSet {
            updateView()
        }
    }
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        // Initialization code
    }
    
    // MARK: - Function
    private func setupUI() {
        avatarImageView.layer.cornerRadius = 15
        avatarImageView.clipsToBounds = true
    }
    
    private func updateView() {
        guard let viewModel = viewModel else {
            return
        }
        nameLabel.text = viewModel.name
        favoriteButton.isSelected = viewModel.isFavorite
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
