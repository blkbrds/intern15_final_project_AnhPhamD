//
//  OtherDrinkCell.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/17/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

// MARK: - Protocol
protocol OtherDrinkCellDelegate: class {
    func pushToDetail(_ cell: OtherDrinkCell, indexPath: IndexPath)
}

final class OtherDrinkCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Properties
    var viewModel: OtherDrinkViewModel? {
        didSet {
            updateView()
        }
    }
    weak var delegate: OtherDrinkCellDelegate?

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configCollectionView()
    }

    // MARK: - Function
    private func configCollectionView() {
        let otherDrinkCollectionView = UINib(nibName: "OtherDrinkCollectionCell", bundle: .main)
        collectionView.register(otherDrinkCollectionView, forCellWithReuseIdentifier: "OtherDrinkCollectionCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func updateView() {
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension OtherDrinkCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else {
            return 0
        }
        return viewModel.numberOfItemsInSection()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OtherDrinkCollectionCell", for: indexPath) as? OtherDrinkCollectionCell else {
            return UICollectionViewCell()
        }
        guard let viewModel = viewModel else {
            return UICollectionViewCell()
        }
        cell.viewModel = viewModel.viewModelCellForItemAt(index: indexPath.row)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.pushToDetail(self, indexPath: indexPath)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension OtherDrinkCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 30) / 2, height: 160)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
