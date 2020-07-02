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
    @IBOutlet private weak var listDrinkTableView: UITableView!
    @IBOutlet private weak var listDrinkCollectionView: UICollectionView!

    // MARK: - Properites
    private var status = Status.tableView
    var viewModel = HomeViewModel()
    var rightBarButton: UIBarButtonItem?

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Identifier.title
        configNavigation()
        configTableView()
        configCollectionView()
        loadAPICategories(category: "c")
        loadAPIDrinkForCategories(keyword: "Ordinary%20Drink")
    }

    // MARK: - Function
    private func configNavigation() {
        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: Identifier.leftBarButton), style: .plain, target: self, action: #selector(sideMenuTouchUpInSide))
        navigationItem.leftBarButtonItem = leftBarButton
        rightBarButton = UIBarButtonItem(image: UIImage(systemName: Identifier.rightCollectionBarButton), style: .plain, target: self, action: #selector(selectionTouchUpInSide))
        navigationItem.rightBarButtonItem = rightBarButton
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
    }

    private func configTableView() {
        let drinkTableViewCell = UINib(nibName: Identifier.drinkTableCell, bundle: .main)
        listDrinkTableView.register(drinkTableViewCell, forCellReuseIdentifier: Identifier.drinkTableCell)
        listDrinkTableView.dataSource = self
        listDrinkTableView.delegate = self
    }

    private func configCollectionView() {
        let tagCollectionCell = UINib(nibName: Identifier.tagCell, bundle: .main)
        tagCollectionView.register(tagCollectionCell, forCellWithReuseIdentifier: Identifier.tagCell)
        let drinkCollectionCell = UINib(nibName: Identifier.drinkCollectionCell, bundle: .main)
        listDrinkCollectionView.register(drinkCollectionCell, forCellWithReuseIdentifier: Identifier.drinkCollectionCell)
        listDrinkCollectionView.dataSource = self
        listDrinkCollectionView.delegate = self
        tagCollectionView.dataSource = self
        tagCollectionView.delegate = self
    }

    private func loadAPICategories(category: String) {
        viewModel.getCategories(category: category) { (done, msg) in
            if done {
                self.tagCollectionView.reloadData()
            } else {
                self.showAlert(msg: msg)
            }
        }
    }

    private func loadAPIDrinkForCategories(keyword: String) {
        viewModel.getDrinkForCategories(keyword: keyword) { (done, msg) in
            if done {
                self.listDrinkTableView.reloadData()
                self.listDrinkCollectionView.reloadData()
            } else {
                self.showAlert(msg: msg)
            }
        }
    }

    @objc private func sideMenuTouchUpInSide() {
        print("aaaaa")
    }

    @objc private func selectionTouchUpInSide() {
        if status == .tableView {
            listDrinkTableView.isHidden = true
            listDrinkCollectionView.isHidden = false
            rightBarButton?.image = UIImage(systemName: Identifier.rightTableBarButton)
            navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
            status = .collectionView
        } else {
            listDrinkTableView.isHidden = false
            listDrinkCollectionView.isHidden = true
            rightBarButton?.image = UIImage(systemName: Identifier.rightCollectionBarButton)
            navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
            status = .tableView
        }
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.drinkTableCell, for: indexPath) as? DrinkTableViewCell else {
            return UITableViewCell()
        }
        cell.indexPath = indexPath
        cell.delegate = self
        cell.viewModel = viewModel.viewModelCellForRowAt(indexPath: indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("aaaaaa: \(indexPath)")
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tagCollectionView {
            return viewModel.numberOfTagsInSection()
        } else {
            return viewModel.numberOfItemsInSection()
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tagCollectionView {
            guard let cell = tagCollectionView.dequeueReusableCell(withReuseIdentifier: Identifier.tagCell, for: indexPath) as? TagCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.viewModel = viewModel.viewModelCellForTags(indexPath: indexPath.row)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.drinkCollectionCell, for: indexPath) as? DrinkCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            cell.indexPath = indexPath
            cell.viewModel = viewModel.viewModelCellForItems(indexPath: indexPath.row)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tagCollectionView {
            let keyword = viewModel.tagGroups[indexPath.row].tagName
            let newKeyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            if let newKeyword = newKeyword {
                loadAPIDrinkForCategories(keyword: newKeyword)
            }
            print("TagCollectionView")
        } else {
            print("ListCollectionView")
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

// MARK: - DrinkTableViewCellDelegate
extension HomeViewController: DrinkTableViewCellDelegate {
    func dowloadImage(cell: DrinkTableViewCell, indexPath: IndexPath) {
        viewModel.getDrinkImageForCategories(at: indexPath) { (indexPath, _) in
            self.listDrinkTableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

// MARK: - DrinkCollectionViewCellDelegate
extension HomeViewController: DrinkCollectionViewCellDelegate {
    func dowloadImage(cell: DrinkCollectionViewCell, indexPath: IndexPath) {
        viewModel.getDrinkImageForCategories(at: indexPath) { (indexPath, _) in
            self.listDrinkCollectionView.reloadItems(at: [indexPath])
        }
    }
}

extension HomeViewController {
    struct Identifier {
        static let tagCell = "TagCollectionViewCell"
        static let drinkCollectionCell = "DrinkCollectionViewCell"
        static let drinkTableCell = "DrinkTableViewCell"
        static let rightTableBarButton =  "square.split.1x2"
        static let rightCollectionBarButton = "square.grid.2x2"
        static let leftBarButton = "text.justify"
        static let title = "Category"
    }
}
