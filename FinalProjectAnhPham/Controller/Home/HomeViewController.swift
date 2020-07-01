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

final class HomeViewController: BaseViewController {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var tagCollectionView: UICollectionView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Properites
    private var status = Status.tableView
    var viewModel = HomeViewModel()
    var rightBarButton: UIBarButtonItem?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Category"
        configNavigation()
        configTableView()
        configCollectionView()
        viewModel.dummyData()
    }
    
    // MARK: - Function
    private func configNavigation() {
        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "text.justify"), style: .plain, target: self, action: #selector(sideMenuTouchUpInSide))
        navigationItem.leftBarButtonItem = leftBarButton
        
        rightBarButton = UIBarButtonItem(image: UIImage(systemName: "square.grid.2x2"), style: .plain, target: self, action: #selector(selectionTouchUpInSide))
        navigationItem.rightBarButtonItem = rightBarButton
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
    }
    
    private func configTableView() {
        let nib = UINib(nibName: "DrinkTableViewCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "DrinkTableViewCell")
        tableView.dataSource = self
    }
    
    private func configCollectionView() {
        let nib = UINib(nibName: "TagCollectionViewCell", bundle: .main)
        tagCollectionView.register(nib, forCellWithReuseIdentifier: "TagCollectionViewCell")
        let nib2 = UINib(nibName: "DrinkCollectionViewCell", bundle: .main)
        collectionView.register(nib2, forCellWithReuseIdentifier: "DrinkCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        tagCollectionView.dataSource = self
        tagCollectionView.delegate = self
    }
    
    @objc func sideMenuTouchUpInSide() {
        print("aaaaa")
    }
    
    @objc func selectionTouchUpInSide() {
        if status == .tableView {
            tableView.isHidden = true
            collectionView.isHidden = false
            rightBarButton?.image = UIImage(systemName: "square.split.1x2")
            navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
            status = .collectionView
        } else {
            tableView.isHidden = false
            collectionView.isHidden = true
            rightBarButton?.image = UIImage(systemName: "square.grid.2x2")
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkTableViewCell", for: indexPath) as? DrinkTableViewCell else {
            return UITableViewCell()
        }
        cell.viewModel = viewModel.viewModelCellForRowAt(indexPath: indexPath.row)
        return cell
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tagCollectionView {
            return viewModel.numberOfTagsInSection()
        } else {
            return viewModel.numberOfItemsInSection()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tagCollectionView {
            guard let cell = tagCollectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath) as? TagCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.viewModel = viewModel.viewModelCellForTags(indexPath: indexPath.row)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DrinkCollectionViewCell", for: indexPath) as? DrinkCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.viewModel = viewModel.viewModelCellForItems(indexPath: indexPath.row)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == tagCollectionView {
            return CGSize(width: 150, height: UIScreen.main.bounds.height / 20)
        } else {
            return CGSize(width: (UIScreen.main.bounds.width - CGFloat(30)) / 2, height: 140)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
