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
    var viewModel = HomeViewModel()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Category"
        configNavigation()
        configTableView()
        viewModel.dummyData()
        let textAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.6784313725, blue: 0.7098039216, alpha: 1)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    // MARK: - Function
    private func configNavigation() {
        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "text.justify"), style: .plain, target: self, action: #selector(sideMenuTouchUpInSide))
        navigationItem.leftBarButtonItem = leftBarButton
        
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "square.grid.2x2"), style: .plain, target: self, action: #selector(selectionTouchUpInSide))
        navigationItem.rightBarButtonItem = rightBarButton
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
    }
    
    private func configTableView() {
        let nib = UINib(nibName: "HomeTableViewCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "HomeTableViewCell")
        tableView.dataSource = self
    }
    
    @objc func sideMenuTouchUpInSide() {
        print("aaaaa")
    }
    
    @objc func selectionTouchUpInSide() {
        if status == .tableView {
            tableView.isHidden = true
            collectionView.isHidden = false
            let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "square.split.1x2"), style: .plain, target: self, action: #selector(selectionTouchUpInSide))
            navigationItem.rightBarButtonItem = rightBarButton
            navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
            status = .collectionView
        } else {
            tableView.isHidden = false
            collectionView.isHidden = true
            let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "square.grid.2x2"), style: .plain, target: self, action: #selector(selectionTouchUpInSide))
            navigationItem.rightBarButtonItem = rightBarButton
            navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
            status = .tableView
        }
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        cell.viewModel = viewModel.viewModelCellForRowAt(indexPath: indexPath.row)
        return cell
    }
}
