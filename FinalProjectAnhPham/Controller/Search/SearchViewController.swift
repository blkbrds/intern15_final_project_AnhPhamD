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

    private func getResultSearchByName(keywork: String) {
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

    private func configTableView() {
        let drinkTableView = UINib(nibName: "SearchCell", bundle: .main)
        drinkResultsTableView.register(drinkTableView, forCellReuseIdentifier: "SearchCell")
        drinkResultsTableView.dataSource = self
        drinkResultsTableView.delegate = self
        drinkResultsTableView.rowHeight = 300
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
        return viewModel.numberOfRowsInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = drinkResultsTableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as? SearchCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.viewModel = viewModel.viewModelCellForRowAt(index: indexPath.row)
        return cell
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
        SVProgressHUD.show()
        guard let keyword = searchBar.text else { return }
        getResultSearchByName(keywork: keyword)
        view.endEditing(true)
    }
}

// MARK: - SearchCellDelegate
extension SearchViewController: SearchCellDelegate {
    func handleFavorite(_ cell: SearchCell, idDrink: String, isFavorite: Bool) {
        if isFavorite {
            viewModel.deleteItemFavorite(idDrink: idDrink)
        } else {
            viewModel.addFavorite(drinkID: cell.viewModel?.drinkID ?? "", nameTitle: cell.viewModel?.nameTitle ?? "", imageUrl: cell.viewModel?.imageURL ?? "")
        }
        drinkResultsTableView.reloadData()
    }
}
