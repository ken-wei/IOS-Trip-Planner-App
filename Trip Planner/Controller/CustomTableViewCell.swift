//
//  CustomTableViewCell.swift
//  Trip Planner
//
//  Created by Jeremy Kane on 8/21/20.
//  Copyright © 2020 RMIT. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var departureDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var airlineLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//
}
