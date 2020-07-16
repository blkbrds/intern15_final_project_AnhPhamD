//
//  HomeViewController.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 6/30/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import LGSideMenuController

final class HomeViewController: BaseViewController {
    
    // MARK: - Enum
    enum Status {
        case tableView
        case collectionView
    }
    
    // MARK: - IBOutlet
    @IBOutlet private weak var tagCollectionView: UICollectionView!
    @IBOutlet private weak var listDrinkTableView: UITableView!
    @IBOutlet private weak var listDrinkCollectionView: UICollectionView!
    
    // MARK: - Properites
    var viewModel = HomeViewModel()
    var rightBarButton: UIBarButtonItem?
    private var status = Status.tableView
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Identifier.title
        configNavigation()
        configTableView()
        configCollectionView()
        getData()
    }
    
    // MARK: - Function
    private func configNavigation() {
        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: Identifier.leftBarButton), style: .plain, target: self, action: #selector(sideMenuTouchUpInSide))
        navigationItem.leftBarButtonItem = leftBarButton
        rightBarButton = UIBarButtonItem(image: UIImage(systemName: Identifier.rightCollectionBarButton), style: .plain, target: self, action: #selector(selectionTouchUpInSide))
        navigationItem.rightBarButtonItem = rightBarButton
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9333333333, green: 0.4352941176, blue: 0.3411764706, alpha: 1)
        if let leftMenu = SceneDelegate.share.sideMenu.leftViewController as? SideMenuViewController {
            leftMenu.delegate = self
        }
    }
    
    private func configTableView() {
        let drinkTableViewCell = UINib(nibName: Identifier.drinkTableCell, bundle: .main)
        listDrinkTableView.register(drinkTableViewCell, forCellReuseIdentifier: Identifier.drinkTableCell)
        listDrinkTableView.dataSource = self
        listDrinkTableView.delegate = self
        listDrinkTableView.rowHeight = UIScreen.main.bounds.height / 3
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
    
    private func getData() {
        viewModel.fetchRealmData()
        loadAPICategories(category: "c=")
        loadAPIDrinkForCategories(firstChar: "c=", keyword: "Ordinary%20Drink")
    }
    
    private func loadAPICategories(category: String) {
        viewModel.getCategories(category: category) { [weak self] (done, msg) in
            guard let this = self else { return }
            if done {
                this.tagCollectionView.reloadData()
            } else {
                this.showAlert(msg: msg)
            }
        }
    }
    
    private func loadAPIDrinkForCategories(firstChar: String, keyword: String) {
        viewModel.getDrinkForCategories(firstChar: firstChar, keyword: keyword) { [weak self] (done, msg) in
            guard let this = self else { return }
            if done {
                this.listDrinkTableView.reloadData()
                this.listDrinkCollectionView.reloadData()
            } else {
                this.showAlert(msg: msg)
            }
        }
    }
    
    @objc private func sideMenuTouchUpInSide() {
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }
    
    @objc private func selectionTouchUpInSide() {
        if status == .tableView {
            listDrinkTableView.isHidden = true
            listDrinkCollectionView.isHidden = false
            rightBarButton?.image = UIImage(systemName: Identifier.rightTableBarButton)
            status = .collectionView
        } else {
            listDrinkTableView.isHidden = false
            listDrinkCollectionView.isHidden = true
            rightBarButton?.image = UIImage(systemName: Identifier.rightCollectionBarButton)
            status = .tableView
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.drinkTableCell, for: indexPath) as? DrinkTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.viewModel = viewModel.viewModelCellForRowAt(indexPath: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailDrinkViewController()
        vc.viewModel = viewModel.viewModelDidSelectRowAt(index: indexPath.row)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
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
            cell.viewModel = viewModel.viewModelCellForItems(indexPath: indexPath.row)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tagCollectionView {
            let keyword = viewModel.tagGroups[indexPath.row].tagName
            let newKeyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            if let newKeyword = newKeyword {
                switch viewModel.status {
                case .category:
                    loadAPIDrinkForCategories(firstChar: "c=", keyword: newKeyword)
                case .glass:
                    loadAPIDrinkForCategories(firstChar: "g=", keyword: newKeyword)
                default:
                    loadAPIDrinkForCategories(firstChar: "a=", keyword: newKeyword)
                }
            }
        } else {
            let vc = DetailDrinkViewController()
            vc.viewModel = viewModel.viewModelDidSelectItemAt(index: indexPath.row)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == tagCollectionView {
            return CGSize(width: 150, height: UIScreen.main.bounds.height / 20)
        } else {
            return CGSize(width: (UIScreen.main.bounds.width - CGFloat(30)) / 2, height: 200)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

// MARK: - HomeViewController
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

// MARK: - SideMenuViewControllerDelegate
extension HomeViewController: SideMenuViewControllerDelegate {
    func sideMenu(_ controller: SideMenuViewController, with item: MenuItem) {
        switch item {
        case .category:
            let catagory = "c="
            loadAPICategories(category: catagory)
            loadAPIDrinkForCategories(firstChar: "c=", keyword: "Ordinary%20Drink")
            title = item.rawValue
            viewModel.status = item
            SceneDelegate.share.sideMenu.hideLeftViewAnimated()
        case .glass:
            let category = "g="
            loadAPICategories(category: category)
            loadAPIDrinkForCategories(firstChar: "g=", keyword: "Highball%20glass")
            title = item.rawValue
            viewModel.status = item
            SceneDelegate.share.sideMenu.hideLeftViewAnimated()
        case .alcoholic:
            let category = "a="
            loadAPICategories(category: category)
            loadAPIDrinkForCategories(firstChar: "a=", keyword: "Alcoholic")
            title = item.rawValue
            viewModel.status = item
            SceneDelegate.share.sideMenu.hideLeftViewAnimated()
        case .favorite:
            let favoriteViewController = FavoriteViewController()
            favoriteViewController.viewModel = FavoriteViewModel(status: viewModel.status)
            favoriteViewController.title = item.rawValue
            favoriteViewController.delegate = self
            navigationController?.pushViewController(favoriteViewController, animated: true)
            SceneDelegate.share.sideMenu.hideLeftViewAnimated()
        default:
            let searchViewController = SearchViewController()
            searchViewController.title = item.rawValue
            navigationController?.pushViewController(searchViewController, animated: true)
            SceneDelegate.share.sideMenu.hideLeftViewAnimated()
        }
    }
}

// MARK: - DrinkTableViewCellDelegate
extension HomeViewController: DrinkTableViewCellDelegate {
    func handleFavoriteTableView(cell: DrinkTableViewCell, idDrink: String, isFavorite: Bool) {
        if isFavorite {
            viewModel.deleteItemFavorite(idDrink: idDrink)
        } else {
            viewModel.addFavorite(idDrink: cell.viewModel?.idDrink ?? "", nameTitle: cell.viewModel?.nameTitle ?? "", imageUrl: cell.viewModel?.imageURL ?? "")
        }
        listDrinkTableView.reloadData()
        listDrinkCollectionView.reloadData()
    }
}

// MARK: - DrinkCollectionViewCellDelegate
extension HomeViewController: DrinkCollectionViewCellDelegate {
    func handleFavoriteCollection(cell: DrinkCollectionViewCell, idDrink: String, isFavorite: Bool) {
        if isFavorite {
            viewModel.deleteItemFavorite(idDrink: idDrink)
        } else {
            viewModel.addFavorite(idDrink: cell.viewModel?.idDrink ?? "", nameTitle: cell.viewModel?.nameTitle ?? "", imageUrl: cell.viewModel?.imageURL ?? "")
        }
        guard let indexPath = listDrinkCollectionView.indexPath(for: cell) else { return }
        listDrinkCollectionView.reloadItems(at: [indexPath])
        listDrinkTableView.reloadData()
    }
}

// MARK: - FavoriteViewControllerDelegate
extension HomeViewController: FavoriteViewControllerDelegate {
    func handleFavoriteCollection(controller: FavoriteViewController, idDrink: String) {
        viewModel.deleteItemFavorite(idDrink: idDrink)
        listDrinkTableView.reloadData()
        listDrinkCollectionView.reloadData()
    }
}
