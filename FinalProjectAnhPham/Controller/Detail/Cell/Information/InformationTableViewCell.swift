//
//  DetailDrinkTableViewCell.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/8/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

final class InformationTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var measureLabel: UILabel!
    
    // MARK: - Properties
    var viewModel: InformationViewModel? {
        didSet {
            updateView()
        }
    }
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Function
    private func updateView() {
        guard let viewModel = viewModel else { return }
        ingredientLabel.text = viewModel.ingredient
        measureLabel.text = viewModel.measure
    }
}
