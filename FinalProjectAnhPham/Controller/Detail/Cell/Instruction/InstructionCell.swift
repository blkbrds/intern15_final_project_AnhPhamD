//
//  InstructionTableViewCell.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/17/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

final class InstructionCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var instructionLabel: UILabel!
    
    // MARK: - Properties
    var viewModel: InstructionViewModel? {
        didSet {
            updateView()
        }
    }

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK: - Function
    private func updateView() {
        guard let viewModel = viewModel else { return }
        instructionLabel.text = viewModel.instruction
    }
}
