//
//  DetailViewController.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/7/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

// MARK: - Enum
enum Favorite {
    case favorite
    case unFavorite
}

final class DetailDrinkViewController: BaseViewController {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var infomationView: UIView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var glassLabel: UILabel!
    @IBOutlet private weak var alcoholicLabel: UILabel!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var informationTableView: UITableView!
    @IBOutlet private weak var sectionTypeTableView: UITableView!
    
    // MARK: - Properties
    var viewModel: DetailDrinkViewModel? {
        didSet {
            loadAPIDetailDrink()
        }
    }
    var rightBarButton: UIBarButtonItem?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        configNavigation()
        setupUI()
    }
    
    // MARK: - Function
    private func loadAPIDetailDrink() {
        guard let viewModel = viewModel else { return }
        viewModel.getDetailDrink(completion: { [weak self] (done, msg) in
            guard let this = self else { return }
            if done {
                this.updateView()
                this.sectionTypeTableView.reloadData()
            } else {
                this.showAlert(msg: msg)
            }
        })
    }
    
    private func configTableView() {
        let detailTableViewCell = UINib(nibName: "DetailTableViewCell", bundle: .main)
        sectionTypeTableView.register(detailTableViewCell, forCellReuseIdentifier: "DetailTableViewCell")
        sectionTypeTableView.dataSource = self
        sectionTypeTableView.sectionHeaderHeight = 40
    }
    
    private func setupUI() {
        avatarImageView.layer.cornerRadius = 10
    }
    
    private func updateView() {
        guard let drink = viewModel?.drink else {
            return
        }
        title = drink.nameTitle
        categoryLabel.text = drink.category
        glassLabel.text = drink.glass
        alcoholicLabel.text = drink.alcoholic
        avatarImageView.loadImageFromUrl(urlString: drink.imageURL)
    }
    
    private func configNavigation() {
        viewModel?.checkFavorite(completion: { [weak self] (done) in
            guard let this = self else { return }
            if done {
                this.viewModel?.status = .unFavorite
                this.rightBarButton = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: this, action: #selector(this.addFavoriteTouchUpInSide))
                this.navigationItem.rightBarButtonItem = this.rightBarButton
            } else {
                this.viewModel?.status = .favorite
                this.rightBarButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: this, action: #selector(this.addFavoriteTouchUpInSide))
                this.navigationItem.rightBarButtonItem = this.rightBarButton
            }
        })
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "ic-back"), style: .plain, target: self, action: #selector(backTouchUpInSide))
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc func backTouchUpInSide() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func addFavoriteTouchUpInSide() {
        if viewModel?.status == .favorite {
            rightBarButton?.image = UIImage(systemName: "heart.fill")
            viewModel?.status = .unFavorite
            guard let drink = viewModel?.drink else { return }
            viewModel?.addFavorite(idDrink: drink.idDrink, nameTitle: drink.nameTitle, imageUrl: drink.imageURL)
        } else {
            viewModel?.deleteItemFavorite()
            rightBarButton?.image = UIImage(systemName: "heart")
            viewModel?.status = .favorite
        }
    }
}

// MARK: - UITableViewDatasource
extension DetailDrinkViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let viewModel = viewModel else {
            return 0
        }
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else {
            return 0
        }
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = sectionTypeTableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as? DetailTableViewCell,
                let value = viewModel?.drink?.instruction else {
                    return UITableViewCell()
            }
            cell.viewModel = DetailCellViewModel(label: value)
            return cell
        case 1:
            guard let cell = sectionTypeTableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as? DetailTableViewCell,
                let value = viewModel?.drink?.ingredient else {
                    return UITableViewCell()
            }
            cell.viewModel = DetailCellViewModel(label: value)
            return cell
        default:
            guard let cell = sectionTypeTableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as? DetailTableViewCell, let value = viewModel?.drink?.measure else {
                return UITableViewCell()
            }
            cell.viewModel = DetailCellViewModel(label: value)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.titleHeaderInSection(section: section)
    }
}
