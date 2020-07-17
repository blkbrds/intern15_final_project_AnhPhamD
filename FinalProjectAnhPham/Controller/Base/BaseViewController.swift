//
//  BaseViewController.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/1/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }

    // MARK: - Function
    func showAlert(msg: String) {
        let alert = UIAlertController(title: "Waring", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            return
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    private func setupUI() {
        let textAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9333333333, green: 0.4352941176, blue: 0.3411764706, alpha: 1)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
}
