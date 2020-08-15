//
//  FooterCollectionView.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 8/11/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

// MARK: - Protocol
protocol FooterCollectionViewDelegate: class {
    func loadMore(_ view: FooterCollectionView)
}

final class FooterCollectionView: UICollectionReusableView {

    // MARK: - IBOutlet
    @IBOutlet weak var loadMoreButton: UIButton!

    // MARK: - Properties
    weak var delegate: FooterCollectionViewDelegate?

    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        loadMoreButton.layer.cornerRadius = 30
        // Initialization code
    }

    // MARK: - IBAction
    @IBAction private func loadMoreButtonTouchUpInSide(_ sender: Any) {
        if let delegate = delegate {
            delegate.loadMore(self)
        }
    }
}
