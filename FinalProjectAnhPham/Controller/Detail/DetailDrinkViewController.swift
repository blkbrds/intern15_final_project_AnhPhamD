//
//  DetailViewController.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/7/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD

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
        loadAPIOtherDrink(firstChar: "a=", keyword: "Non%20Alcoholic")
        setupUI()
    }

    // MARK: - Function
    private func loadAPIDetailDrink() {
        guard let viewModel = viewModel else { return }
        viewModel.getDetailDrink(completion: { [weak self] (done, msg) in
            SVProgressHUD.dismiss()
            guard let this = self else { return }
            if done {
                this.updateView()
            } else {
                this.showAlert(msg: msg)
            }
        })
    }

    private func loadAPIOtherDrink(firstChar: String, keyword: String) {
        guard let viewModel = viewModel else { return }
        viewModel.getOtherDrink(firstChar: firstChar, keyword: keyword) { [weak self] (done, msg) in
            guard let this = self else { return }
            if done {
                this.sectionTypeTableView.reloadData()
            } else {
                this.showAlert(msg: msg)
            }
        }
    }

    private func configTableView() {
        let instructionTableViewCell = UINib(nibName: "InstructionCell", bundle: .main)
        sectionTypeTableView.register(instructionTableViewCell, forCellReuseIdentifier: "InstructionCell")
        let materialTableViewCell = UINib(nibName: "MaterialCell", bundle: .main)
        sectionTypeTableView.register(materialTableViewCell, forCellReuseIdentifier: "MaterialCell")
        let otherDrinkCell = UINib(nibName: "OtherDrinkCell", bundle: .main)
        sectionTypeTableView.register(otherDrinkCell, forCellReuseIdentifier: "OtherDrinkCell")
        sectionTypeTableView.dataSource = self
        sectionTypeTableView.delegate = self
        sectionTypeTableView.sectionHeaderHeight = 40
    }

    private func setupUI() {
        avatarImageView.layer.cornerRadius = 10
    }

    private func updateView() {
        guard let drink = viewModel?.drink else {
            return
        }
        sectionTypeTableView.reloadData()
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
            viewModel?.addFavorite(drinkID: drink.drinkID, nameTitle: drink.nameTitle, imageUrl: drink.imageURL)
        } else {
            viewModel?.deleteItemFavorite()
            rightBarButton?.image = UIImage(systemName: "heart")
            viewModel?.status = .favorite
        }
    }
}

// MARK: - UITableViewDatasource, UITableViewDelegate
extension DetailDrinkViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = viewModel?.sections[indexPath.section] else { return UITableViewCell() }
        switch sectionType {
        case .instruction:
            guard let cell = sectionTypeTableView.dequeueReusableCell(withIdentifier: "InstructionCell", for: indexPath) as? InstructionCell else {
                return UITableViewCell()
            }
            cell.viewModel = viewModel?.viewModelCellForRowAt(index: indexPath.row)
            return cell
        case .material:
            guard let cell = sectionTypeTableView.dequeueReusableCell(withIdentifier: "MaterialCell", for: indexPath) as? MaterialCell else {
                return UITableViewCell()
            }
            cell.viewModel = viewModel?.viewModelCellForRowAt2(index: indexPath.row)
            return cell
        case .other:
            guard let cell = sectionTypeTableView.dequeueReusableCell(withIdentifier: "OtherDrinkCell", for: indexPath) as? OtherDrinkCell else {
                return UITableViewCell()
            }
            if let viewModel = viewModel {
                cell.viewModel = viewModel.viewModelCellForRowAt3()
            }
            cell.delegate = self
            return cell
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.titleHeaderInSection(section: section)
    }
}

extension DetailDrinkViewController: OtherDrinkCellDelegate {
    func pushToDetail(_ cell: OtherDrinkCell, indexPath: IndexPath) {
        let vc = DetailDrinkViewController()
        vc.viewModel = viewModel?.viewModelDidSelectItemAt(index: indexPath.row)
        SVProgressHUD.show()
        navigationController?.pushViewController(vc, animated: true)
    }
}
