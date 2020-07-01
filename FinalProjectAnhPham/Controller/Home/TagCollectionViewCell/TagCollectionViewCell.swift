//
//  TagCollectionViewCell.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 6/30/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var tagNameLabel: UILabel!
    
    // MARK: - Properties
    var viewModel: TagCellViewModel? {
        didSet {
            updateView()
        }
    }
    
    // MARK: - Life Cycel
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - Function
    private func updateView() {
        guard let viewModel = viewModel else {
            return
        }
        tagNameLabel.text = viewModel.tagName
    }
}
