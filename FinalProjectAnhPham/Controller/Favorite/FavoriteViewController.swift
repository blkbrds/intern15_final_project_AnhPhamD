//
//  FavoriteViewController.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/6/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

final class FavoriteViewController: BaseViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var favoriteCollectionView: UICollectionView!

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigation()
        // Do any additional setup after loading the view.
    }

    // MARK: - Function
    private func configNavigation() {
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "ic-back"), style: .plain, target: self, action: #selector(backTouchUpInSide))
        navigationItem.leftBarButtonItem = leftBarButton
        
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteTouchUpInSide))
        navigationItem.rightBarButtonItem = rightBarButton
    }

    @objc func backTouchUpInSide() {
        navigationController?.popToRootViewController(animated: true)
    }

    @objc func deleteTouchUpInSide() {
        
    }
}
