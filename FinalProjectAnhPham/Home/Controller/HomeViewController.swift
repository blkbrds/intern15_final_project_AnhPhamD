//
//  HomeViewController.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 6/30/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

// MARK: - Enum
enum Status {
    case tableView
    case collectionView
}

final class HomeViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var tagCollectionView: UICollectionView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Properites
    private var status = Status.tableView
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Category"
        configNavigation()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.6784313725, blue: 0.7098039216, alpha: 1)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    // MARK: - Function
    private func configNavigation() {
        let sideMenu = UIBarButtonItem(image: UIImage(systemName: "text.justify"), style: .plain, target: self, action: #selector(sideMenuTouchUpInSide))
        navigationItem.leftBarButtonItem = sideMenu
        
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.grid.2x2"), style: .plain, target: self, action: #selector(selection))
        navigationItem.rightBarButtonItem = barButtonItem
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
    }
    
    @objc func sideMenuTouchUpInSide() {
        print("aaaaa")
    }
    
    @objc func selection() {
        if status == .tableView {
            tableView.isHidden = true
            collectionView.isHidden = false
            let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.split.1x2"), style: .plain, target: self, action: #selector(selection))
            navigationItem.rightBarButtonItem = barButtonItem
            navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
            status = .collectionView
        } else {
            tableView.isHidden = false
            collectionView.isHidden = true
            let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.grid.2x2"), style: .plain, target: self, action: #selector(selection))
            navigationItem.rightBarButtonItem = barButtonItem
            navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
            status = .tableView
        }
    }
}
