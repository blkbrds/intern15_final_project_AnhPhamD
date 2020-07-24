//
//  SearchViewController.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/6/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD

final class SearchViewController: BaseViewController {

    // MARK: - IBOutlet
    @IBOutlet private weak var drinkResultsTableView: UITableView!
    @IBOutlet weak var listSearchHistoryTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet weak var notificationImageView: UIImageView!

    // MARK: - Properties
    var viewModel = SearchViewModel()

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigation()
        configTableView()
        getData()
        searchBar.delegate = self
    }

    // MARK: - Function
    private func getData() {
        viewModel.fetchRealmData()
    }
    
    private func fetchData() {
        viewModel.fetchSearchHistoryData { [weak self] (done, msg) in
            guard let this = self else { return }
            if done {
                this.listSearchHistoryTableView.reloadData()
            } else {
                this.showAlert(msg: msg)
            }
        }
    }

    private func getResultSearchByName(keywork: String) {
        SVProgressHUD.show()
        viewModel.getResultSearchByName(keywork: keywork) { [weak self] (done, _) in
            SVProgressHUD.dismiss()
            guard let this = self else { return }
            if done {
                this.drinkResultsTableView.isHidden = false
                this.notificationImageView.isHidden = true
                this.drinkResultsTableView.reloadData()
            } else {
                this.drinkResultsTableView.isHidden = true
                this.notificationImageView.isHidden = false
                this.notificationImageView.image = UIImage(named: "im-nodata")
            }
        }
    }
    
    private func addSearchHistory(keywork: String) {
        viewModel.addSearchHistory(searchKey: keywork) { [weak self] (done) in
            guard let this = self else { return }
            if done {
                this.fetchData()
            } else {
                this.showAlert(msg: "Error")
            }
        }
    }

    private func configTableView() {
        let drinkTableView = UINib(nibName: "SearchResultCell", bundle: .main)
        drinkResultsTableView.register(drinkTableView, forCellReuseIdentifier: "SearchResultCell")
        drinkResultsTableView.dataSource = self
        drinkResultsTableView.delegate = self
        drinkResultsTableView.rowHeight = 300
        let searchKeyTableView = UINib(nibName: "SearchKeyworkCell", bundle: .main)
        listSearchHistoryTableView.register(searchKeyTableView, forCellReuseIdentifier: "SearchKeyworkCell")
        listSearchHistoryTableView.dataSource = self
        listSearchHistoryTableView.rowHeight = 30
    }

    private func configNavigation() {
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "ic-back"), style: .plain, target: self, action: #selector(backTouchUpInSide))
        navigationItem.leftBarButtonItem = leftBarButton
    }

    @objc func backTouchUpInSide() {
        if let vc = navigationController?.viewControllers[0] as? HomeViewController {
            vc.viewModel.status = viewModel.status
            navigationController?.popToViewController(vc, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == drinkResultsTableView {
        return viewModel.numberOfRowsInSection()
        } else {
            return viewModel.numberOfRowsInSectionHistory()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == drinkResultsTableView {
            guard let cell = drinkResultsTableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as? SearchResultCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.viewModel = viewModel.viewModelCellForRowAt(index: indexPath.row)
            return cell
        } else {
            guard let cell = listSearchHistoryTableView.dequeueReusableCell(withIdentifier: "SearchKeyworkCell", for: indexPath) as? SearchKeyworkCell else {
                return UITableViewCell()
            }
            cell.viewModel = viewModel.viewModelSearchKeyCellForRowAt(index: indexPath.row)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailDrinkViewController()
        vc.viewModel = viewModel.viewModelDidSelectRowAt(index: indexPath.row)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else { return }
        addSearchHistory(keywork: keyword)
        getResultSearchByName(keywork: keyword)
        view.endEditing(true)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        listSearchHistoryTableView.isHidden = false
        fetchData()
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        listSearchHistoryTableView.isHidden = true
        return true
    }
}

// MARK: - SearchCellDelegate
extension SearchViewController: SearchCellDelegate {
    func handleFavorite(_ cell: SearchResultCell, idDrink: String, isFavorite: Bool) {
        if isFavorite {
            viewModel.deleteItemFavorite(idDrink: idDrink)
        } else {
            viewModel.addFavorite(drinkID: cell.viewModel?.drinkID ?? "", nameTitle: cell.viewModel?.nameTitle ?? "", imageUrl: cell.viewModel?.imageURL ?? "")
        }
        drinkResultsTableView.reloadData()
    }
}
