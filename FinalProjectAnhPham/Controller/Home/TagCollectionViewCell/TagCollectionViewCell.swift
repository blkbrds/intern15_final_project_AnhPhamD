//
//  TagCollectionViewCell.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 6/30/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

final class TagCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlet
    @IBOutlet private weak var tagNameLabel: UILabel!
    @IBOutlet private weak var footerView: UIView!

    // MARK: - Properties
    var viewModel: TagCellViewModel? {
        didSet {
            updateView()
        }
    }

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Function
    private func updateView() {
        guard let viewModel = viewModel else { return }
        tagNameLabel.text = viewModel.tagName
    }
}
