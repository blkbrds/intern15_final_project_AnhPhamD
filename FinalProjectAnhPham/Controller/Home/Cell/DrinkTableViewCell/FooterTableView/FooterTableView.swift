//
//  FooterTableView.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 8/11/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

// MARK: - Protocol
protocol FooterTableViewDelegate: class {
    func loadMore(_ view: FooterTableView)
}

final class FooterTableView: UIView {

    // MARK: - IBOutlet
    @IBOutlet weak var loadMoreButton: UIButton!

    // MARK: - Properties
    weak var delegate: FooterTableViewDelegate?

    // MARK: - Function
    func setupUI() {
        loadMoreButton.layer.cornerRadius = 30
    }

    // MARK: - IBAction
    @IBAction private func loadMoreButtonTouchUpInSide(_ sender: Any) {
        if let delegate = delegate {
            delegate.loadMore(self)
        }
    }
}
