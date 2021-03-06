//
//  HomeViewController.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 6/30/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import LGSideMenuController
import SVProgressHUD

final class HomeViewController: BaseViewController {
    
    // MARK: - Enum
    enum TypeDisplay {
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
    private var statusList = TypeDisplay.collectionView
    private var oldTagIndex: Int?
    private var newTagIndex = 0 {
        willSet {
            oldTagIndex = newTagIndex
        }
        
        didSet {
            if let index = oldTagIndex, index != newTagIndex {
                tagCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
            }
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Category"
        configNavigation()
        configTableView()
        configCollectionView()
        configSyncRealmData()
        getData()
    }
    
    // MARK: - Function
    private func configSyncRealmData() {
        viewModel.delegate = self
        viewModel.setupObserve()
    }
    
    private func configNavigation() {
        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "text.justify"), style: .plain, target: self, action: #selector(sideMenuTouchUpInSide))
        navigationItem.leftBarButtonItem = leftBarButton
        rightBarButton = UIBarButtonItem(image: UIImage(systemName: "square.split.1x2"), style: .plain, target: self, action: #selector(selectionTouchUpInSide))
        navigationItem.rightBarButtonItem = rightBarButton
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9333333333, green: 0.4352941176, blue: 0.3411764706, alpha: 1)
        if let leftMenu = SceneDelegate.share.sideMenu.leftViewController as? SideMenuViewController {
            leftMenu.delegate = self
        }
    }
    
    private func configTableView() {
        let drinkTableViewCell = UINib(nibName: "DrinkTableViewCell", bundle: .main)
        listDrinkTableView.register(drinkTableViewCell, forCellReuseIdentifier: "DrinkTableViewCell")
        listDrinkTableView.dataSource = self
        listDrinkTableView.delegate = self
        listDrinkTableView.rowHeight = UIScreen.main.bounds.height / 3
    }
    
    private func configCollectionView() {
        let tagCollectionCell = UINib(nibName: "TagCollectionViewCell", bundle: .main)
        tagCollectionView.register(tagCollectionCell, forCellWithReuseIdentifier: "TagCollectionViewCell")
        let drinkCollectionCell = UINib(nibName: "DrinkCollectionViewCell", bundle: .main)
        listDrinkCollectionView.register(drinkCollectionCell, forCellWithReuseIdentifier: "DrinkCollectionViewCell")
        let foooterCollectionView = UINib(nibName: "FooterCollectionView", bundle: .main)
        listDrinkCollectionView.register(foooterCollectionView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterCollectionView")
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
    
    private func clearData() {
        viewModel.clearData()
        listDrinkTableView.reloadData()
        listDrinkCollectionView.reloadData()
    }
    
    private func resetValue() {
        viewModel.resetValue()
    }
    
    private func loadAPICategories(category: String) {
        SVProgressHUD.show()
        viewModel.getCategories(category: category) { [weak self] (done, msg) in
            SVProgressHUD.dismiss()
            guard let this = self else { return }
            if done {
                this.tagCollectionView.reloadData()
            } else {
                this.showAlert(msg: msg)
            }
        }
    }
    
    private func setupFooterTableView() {
        if viewModel.drinks.count >= 20 {
            let footerTableView = Bundle.main.loadNibNamed("FooterTableView", owner: self, options: nil)?.first as? FooterTableView
            if let footerTableView = footerTableView {
                footerTableView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60)
                footerTableView.delegate = self
                footerTableView.setupUI()
            }
            listDrinkTableView.tableFooterView = footerTableView
        } else {
            listDrinkTableView.tableFooterView?.frame.size.height = 0.001
        }
    }
    
    private func loadAPIDrinkForCategories(firstChar: String, keyword: String) {
        SVProgressHUD.show()
        viewModel.getDrinkForCategories(firstChar: firstChar, keyword: keyword) { [weak self] (done, msg) in
            SVProgressHUD.dismiss()
            guard let this = self else { return }
            if done {
                this.resetValue()
                this.setupFooterTableView()
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
        if statusList == .tableView {
            listDrinkTableView.isHidden = true
            listDrinkCollectionView.isHidden = false
            rightBarButton?.image = UIImage(systemName: "square.split.1x2")
            statusList = .collectionView
        } else {
            listDrinkTableView.isHidden = false
            listDrinkCollectionView.isHidden = true
            rightBarButton?.image = UIImage(systemName: "square.grid.2x2")
            statusList = .tableView
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkTableViewCell", for: indexPath) as? DrinkTableViewCell else {
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
            guard let cell = tagCollectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath) as? TagCollectionViewCell else {
                return UICollectionViewCell()
            }
            if newTagIndex == indexPath.row {
                cell.isSelectedCell = true
                cell.isSelected = true
            } else {
                cell.isSelectedCell = false
                cell.isSelected = false
            }
            cell.viewModel = viewModel.viewModelCellForTags(indexPath: indexPath.row)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DrinkCollectionViewCell", for: indexPath) as? DrinkCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            cell.viewModel = viewModel.viewModelCellForItems(indexPath: indexPath.row)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tagCollectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) as? TagCollectionViewCell else { return }
            cell.isSelectedCell = true
            newTagIndex = indexPath.row
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if collectionView == listDrinkCollectionView {
            if !viewModel.canLoadMore {
                return CGSize(width: UIScreen.main.bounds.width, height: CGFloat.leastNonzeroMagnitude)
            } else {
                return CGSize(width: UIScreen.main.bounds.width, height: 60)
            }
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == listDrinkCollectionView {
            switch kind {
            case UICollectionView.elementKindSectionFooter:
                guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterCollectionView",
                    for: indexPath) as? FooterCollectionView else {
                    return UICollectionReusableView()
                }
                footer.delegate = self
                return footer
            default:
                return UICollectionReusableView()
            }
        }
        return UICollectionReusableView()
    }
}

// MARK: - SideMenuViewControllerDelegate
extension HomeViewController: SideMenuViewControllerDelegate {
    func sideMenu(_ controller: SideMenuViewController, with item: MenuItem) {
        switch item {
        case .category:
            clearData()
            newTagIndex = 0
            let catagory = "c="
            loadAPICategories(category: catagory)
            loadAPIDrinkForCategories(firstChar: "c=", keyword: "Ordinary%20Drink")
            title = item.rawValue
            viewModel.status = item
        case .glass:
            clearData()
            newTagIndex = 0
            let category = "g="
            loadAPICategories(category: category)
            loadAPIDrinkForCategories(firstChar: "g=", keyword: "Highball%20glass")
            title = item.rawValue
            viewModel.status = item
        case .alcoholic:
            clearData()
            newTagIndex = 0
            let category = "a="
            loadAPICategories(category: category)
            loadAPIDrinkForCategories(firstChar: "a=", keyword: "Alcoholic")
            title = item.rawValue
            viewModel.status = item
        case .favorite:
            let favoriteViewController = FavoriteViewController()
            favoriteViewController.viewModel = FavoriteViewModel(status: viewModel.status)
            favoriteViewController.title = item.rawValue
            navigationController?.pushViewController(favoriteViewController, animated: true)
        default:
            let searchViewController = SearchViewController()
            searchViewController.viewModel = SearchViewModel(status: viewModel.status)
            searchViewController.title = item.rawValue
            navigationController?.pushViewController(searchViewController, animated: true)
        }
        SceneDelegate.share.sideMenu.hideLeftViewAnimated()
    }
}

// MARK: - DrinkTableViewCellDelegate
extension HomeViewController: DrinkTableViewCellDelegate {
    func handleFavoriteTableView(cell: DrinkTableViewCell, drinkID: String, isFavorite: Bool) {
        if isFavorite {
            viewModel.deleteItemFavorite(drinkID: drinkID)
        } else {
            viewModel.addFavorite(drinkID: cell.viewModel?.drinkID ?? "", nameTitle: cell.viewModel?.nameTitle ?? "", imageUrl: cell.viewModel?.imageURL ?? "")
        }
        listDrinkTableView.reloadData()
        listDrinkCollectionView.reloadData()
    }
}

// MARK: - DrinkCollectionViewCellDelegate
extension HomeViewController: DrinkCollectionViewCellDelegate {
    func handleFavoriteCollection(cell: DrinkCollectionViewCell, drinkID: String, isFavorite: Bool) {
        if isFavorite {
            viewModel.deleteItemFavorite(drinkID: drinkID)
        } else {
            viewModel.addFavorite(drinkID: cell.viewModel?.drinkID ?? "", nameTitle: cell.viewModel?.nameTitle ?? "", imageUrl: cell.viewModel?.imageURL ?? "")
        }
        guard let indexPath = listDrinkCollectionView.indexPath(for: cell) else { return }
        listDrinkCollectionView.reloadItems(at: [indexPath])
        listDrinkTableView.reloadData()
    }
}

// MARK: - HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {
    func syncFavorite(viewModel: HomeViewModel, needperformAction action: HomeViewModel.Action) {
        listDrinkTableView.reloadData()
        listDrinkCollectionView.reloadData()
    }
}

// MARK: - FooterTableViewDelegate
extension HomeViewController: FooterTableViewDelegate {
    func loadMore(_ view: FooterTableView) {
        viewModel.loadMore()
        listDrinkTableView.reloadData()
        listDrinkCollectionView.reloadData()

        if !viewModel.canLoadMore {
            let footerTableView = listDrinkTableView.tableFooterView
            footerTableView?.frame.size.height = CGFloat.leastNonzeroMagnitude
            footerTableView?.isHidden = true
            listDrinkTableView.tableFooterView = footerTableView
        }
    }
}

// MARK: - FooterCollectionViewDelegate
extension HomeViewController: FooterCollectionViewDelegate {
    func loadMore(_ view: FooterCollectionView) {
        viewModel.loadMore()
        listDrinkTableView.reloadData()
        listDrinkCollectionView.reloadData()
        
        if !viewModel.canLoadMore {
            let footerTableView = listDrinkTableView.tableFooterView
            footerTableView?.frame.size.height = CGFloat.leastNonzeroMagnitude
            footerTableView?.isHidden = true
            listDrinkTableView.tableFooterView = footerTableView
        }
    }
}
