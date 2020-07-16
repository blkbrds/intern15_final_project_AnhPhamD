//
//  FavoriteViewController.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/6/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

protocol FavoriteViewControllerDelegate: class {
    func handleFavoriteCollection(controller: FavoriteViewController, idDrink: String)
}

final class FavoriteViewController: BaseViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var listFavoriteCollectionView: UICollectionView!
    
    // MARK: - Properties
    var viewModel = FavoriteViewModel()
    weak var delegate: FavoriteViewControllerDelegate?

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigation()
        configCollectionView()
        fectchData()
        // Do any additional setup after loading the view.
    }

    // MARK: - Function
    private func fectchData() {
        viewModel.fetchRealmData { [weak self] (done) in
            guard let this = self else { return }
            if done {
                this.listFavoriteCollectionView.reloadData()
            } else {
                showAlert(msg: "Error")
            }
        }
    }
    
    private func deleteItemFavorite(idDrink: String) {
        viewModel.deleteItemFavorite(idDrink: idDrink) { [weak self] (done) in
            guard let this = self else { return }
            if done {
                this.fectchData()
            } else {
                print("Delete error")
            }
        }
    }
    
    private func deleteAllItem() {
        viewModel.deleteAllItem { [weak self] (done) in
            guard let this = self else { return }
            if done {
                this.fectchData()
            } else {
                print("Delete failed")
            }
        }
    }
    
    private func configCollectionView() {
        let collectionView = UINib(nibName: "FavoriteCell", bundle: .main)
        listFavoriteCollectionView.register(collectionView, forCellWithReuseIdentifier: "FavoriteCell")
        listFavoriteCollectionView.dataSource = self
        listFavoriteCollectionView.delegate = self
    }
    
    private func configNavigation() {
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "ic-back"), style: .plain, target: self, action: #selector(backTouchUpInSide))
        navigationItem.leftBarButtonItem = leftBarButton
        
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteTouchUpInSide))
        navigationItem.rightBarButtonItem = rightBarButton
    }

    @objc func backTouchUpInSide() {
        if let vc = navigationController?.viewControllers[0] as? HomeViewController {
            vc.viewModel.status = viewModel.status
            navigationController?.popToViewController(vc, animated: true)
        }
    }

    @objc func deleteTouchUpInSide() {
        let alert = UIAlertController(title: "Warning", message: "Delete all", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .destructive) { [weak self] (_) in
            guard let this = self else { return }
            this.deleteAllItem()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension FavoriteViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = listFavoriteCollectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as? FavoriteCell else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        cell.viewModel = viewModel.viewModelCellForItemAt(index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailDrinkViewController()
        vc.viewModel = viewModel.viewModelDidSelectItemAt(index: indexPath.row)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - CGFloat(30)) / 2, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

// MARK: - DrinkCollectionViewCellDelegate
extension FavoriteViewController: FavoriteCellDelegate {
    func handleFavorite(cell: FavoriteCell, idDrink: String, isFavorite: Bool) {
        if let delegate = delegate {
            delegate.handleFavoriteCollection(controller: self, idDrink: idDrink)
        }
        deleteItemFavorite(idDrink: idDrink)
    }
}
