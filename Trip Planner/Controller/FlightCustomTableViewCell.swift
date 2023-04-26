//
//  FlightCustomTableViewCell.swift
//  Trip Planner
//
//  Created by Ken Wei Ooi on 30/08/2020.
//  Copyright © 2020 RMIT. All rights reserved.
//

import UIKit

class FlightCustomTableViewCell: UITableViewCell {

    @IBOutlet weak var airlineLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var arrivalLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var flightIcon: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    weak var parentView: FlightInfoViewController!
    var flightResult: Flight!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func addToPlan(_ sender: Any) {
//        print(flightResult)
        let planViewModel = parentView.homeView.modelController.planViewModel
        
        if(planViewModel!.checkExistence(flight: flightResult)){
            parentView.createAlert(title: "Plan Exist!", message:"")
        }
        else{
            parentView.createAlert(title: "Plan Added!",message:"")
            print(flightResult)
            planViewModel?.addPlan(flight: flightResult)
        }
    }
}
