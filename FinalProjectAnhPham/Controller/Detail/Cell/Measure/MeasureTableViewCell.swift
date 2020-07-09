//
//  MeasureTableViewCell.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/8/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

class MeasureTableViewCell: UITableViewCell {

    @IBOutlet weak var measureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var viewModel: DetailCellViewModel? {
        didSet {
            updateView()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func updateView() {
        guard let viewModel = viewModel else {
            return
        }
        measureLabel.text = viewModel.label
    }
}
