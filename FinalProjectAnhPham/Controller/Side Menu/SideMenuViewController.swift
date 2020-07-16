//
//  SideMenuViewController.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/3/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

// MARK: - Protocol
protocol SideMenuViewControllerDelegate: class {
    func sideMenu(_ view: SideMenuViewController, with item: MenuItem)
}

final class SideMenuViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet private weak var sideMenuTableView: UITableView!

    // MARK: - Properties
    var viewModel = SideMenuViewModel()
    weak var delegate: SideMenuViewControllerDelegate?

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
    }

    // MARK: - Function
    private func configTableView() {
        let sideMenuTableViewCell = UINib(nibName: "SideMenuCell", bundle: .main)
        sideMenuTableView.register(sideMenuTableViewCell, forCellReuseIdentifier: "SideMenuCell")
        sideMenuTableView.dataSource = self
        sideMenuTableView.delegate = self
        sideMenuTableView.rowHeight = 60
    }
}

// MARK: - UITableViewDatasource, UITableViewDelegate
extension SideMenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = sideMenuTableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as? SideMenuCell else {
            return UITableViewCell()
        }
        cell.viewModel = viewModel.viewModelCellForRowAt(index: indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = viewModel.getMenuItem(at: indexPath.row) else { return }
        if let delegate = delegate {
            delegate.sideMenu(self, with: item)
        }
    }
}
