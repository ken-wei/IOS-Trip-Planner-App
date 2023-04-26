//
//  PlanDetailViewController.swift
//  Trip Planner
//
//  Created by Jeremy Kane on 8/23/20.
//  Copyright © 2020 RMIT. All rights reserved.
//

import UIKit

class PlanDetailViewController: UIViewController {
    
    @IBOutlet weak var source1: UILabel!
    @IBOutlet weak var destination1: UILabel!
    @IBOutlet weak var date1: UILabel!
    @IBOutlet weak var source2: UILabel!
    @IBOutlet weak var destination2: UILabel!
    @IBOutlet weak var date2: UILabel!
    @IBOutlet weak var airlineLabel1: UILabel!
    @IBOutlet weak var directLabel1: UILabel!
    @IBOutlet weak var airlineLabel2: UILabel!
    @IBOutlet weak var directLabel2: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var returnDetail: UIView!
    @IBOutlet weak var departureDetailView: UIView!
    @IBOutlet weak var returnDetailView: UIView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var noteLabel: UITextField!
    var viewModel: PlanViewModel!
    var detail:Flight!
    var modelController: ModelController!
    //fill in the details for each labels from the intended detail passed from PlanViewController tapped Cell
    override func viewDidLoad() {
        super.viewDidLoad()
        returnDetail.alpha = 0
        self.source1.text = self.detail?.source
        self.destination1.text = self.detail?.destination
        self.price.text =  "\(self.detail?.price ??  "")"
        self.date1.text = self.detail?.departureDate
        self.noteLabel.text = self.detail?.note
        self.noteLabel.placeholder = "Enter Note Here"
        if(self.detail?.returnDate != ""){
            returnDetail.alpha = 1
            self.source2.text = self.detail?.destination
            self.destination2.text = self.detail?.source
            self.date2.text = self.detail?.returnDate
            
        }
        self.airlineLabel1.text = self.detail?.airline
        self.directLabel1.text = "\(self.detail?.direct ?? "") Flight"
        self.airlineLabel2.text = self.detail?.airline
        self.directLabel2.text = "\(self.detail?.direct ?? "") Flight"
       
        departureDetailView.backgroundColor = UIColor(white: 1, alpha: 0.7)
        
        returnDetailView.backgroundColor = UIColor(white: 1, alpha:0.7)
        
        priceView.backgroundColor = UIColor(white:1, alpha:0.7)
        
        departureDetailView.layer.cornerRadius = 10
        returnDetailView.layer.cornerRadius = 10
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Update the viewmodel based on the dependency injection pattern
        self.viewModel = PlanViewModel()
        
    }
    
    @IBAction func handleNoteChange(_ sender: Any) {
        self.viewModel.updateNote(flight: self.detail!, text: self.noteLabel.text!)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
