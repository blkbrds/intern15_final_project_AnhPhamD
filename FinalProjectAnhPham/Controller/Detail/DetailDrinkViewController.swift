//
//  DetailViewController.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/7/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

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
    @IBOutlet weak var sectionTypeTableView: UITableView!
    
    // MARK: - Properties
    var viewModel: DetailDrinkViewModel? {
        didSet {
            loadAPIDetailDrink()
        }
    }
    var status = Favorite.favorite
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
        let instructionTableViewCell = UINib(nibName: "InstructionTableViewCell", bundle: .main)
        let ingredientTableViewCell = UINib(nibName: "IngredientTableViewCell", bundle: .main)
        let measureTableViewCell = UINib(nibName: "MeasureTableViewCell", bundle: .main)
        sectionTypeTableView.register(instructionTableViewCell, forCellReuseIdentifier: "InstructionTableViewCell")
        sectionTypeTableView.register(ingredientTableViewCell, forCellReuseIdentifier: "IngredientTableViewCell")
        sectionTypeTableView.register(measureTableViewCell, forCellReuseIdentifier: "MeasureTableViewCell")
        sectionTypeTableView.dataSource = self
    }
    
    private func setupUI() {
        infomationView.layer.cornerRadius = 30
        infomationView.clipsToBounds = true
        stackView.layer.cornerRadius = 20
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
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "ic-back"), style: .plain, target: self, action: #selector(backTouchUpInSide))
        navigationItem.leftBarButtonItem = leftBarButton
        rightBarButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(favoriteTouchUpInSide))
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func backTouchUpInSide() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func favoriteTouchUpInSide() {
        if status == .favorite {
            rightBarButton?.image = UIImage(systemName: "heart.fill")
            status = .unFavorite
        } else {
            rightBarButton?.image = UIImage(systemName: "heart")
            status = .favorite
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.titleHeaderInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = sectionTypeTableView.dequeueReusableCell(withIdentifier: "InstructionTableViewCell", for: indexPath) as? InstructionTableViewCell,
                let value = viewModel?.drink?.instruction else {
                return UITableViewCell()
            }
            cell.viewModel = DetailCellViewModel(label: value)
            return cell
        case 1:
            guard let cell = sectionTypeTableView.dequeueReusableCell(withIdentifier: "IngredientTableViewCell", for: indexPath) as? IngredientTableViewCell, let value = viewModel?.drink?.ingredient else {
                return UITableViewCell()
            }
            cell.viewModel = DetailCellViewModel(label: value)
            return cell
        default:
            guard let cell = sectionTypeTableView.dequeueReusableCell(withIdentifier: "MeasureTableViewCell", for: indexPath) as? MeasureTableViewCell, let value = viewModel?.drink?.measure else {
                return UITableViewCell()
            }
            cell.viewModel = DetailCellViewModel(label: value)
            return cell
        }
    }
}
