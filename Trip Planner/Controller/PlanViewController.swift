//
//  PlanController.swift
//  Trip Planner
//
//  Created by Jeremy Kane on 8/20/20.
//  Copyright © 2020 RMIT. All rights reserved.
//

import UIKit

class PlanController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //initialize local variable and view outlet
    @IBOutlet weak var noPlansLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedButton: UISegmentedControl!
    private var viewModel: PlanViewModel!
    var modelController: ModelController!
    private var viewUpcoming:Bool!
    let backgroundImage = UIImage(named: "background2.png")
    let cellSpacingHeight: CGFloat = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CustomTableViewCell")
        self.tableView.rowHeight = 130.0
        self.viewUpcoming = true
        self.noPlansLabel.layer.backgroundColor = UIColor(white:1,alpha:0.7).cgColor
        self.noPlansLabel.layer.cornerRadius = 8
        tableView.backgroundColor = UIColor.clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Update the viewmodel based on the dependency injection pattern
//        print(modelController)
        self.viewModel = modelController.planViewModel
        self.tableView.reloadData()
        noPlansLabel.alpha = 0
        self.updateUpcomingView()
    }
    
    
    //update the view between histroy and upcoming for the segmented button
    @IBAction func toggleView(_ sender: UISegmentedControl) {
        
        self.noPlansLabel.alpha = 0
        if(sender.selectedSegmentIndex==0){
            self.viewUpcoming = true
            print(viewModel.getUpcoming().count)
            self.updateUpcomingView()
        }
        else{
            self.updateHistoryView()
            self.viewUpcoming = false
        }
        
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(self.viewUpcoming){
            return viewModel.getUpcoming().count
        }
        else{
            return viewModel.getHistory().count
        }    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    //populate the cell with the data intended
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        
        if(self.viewUpcoming){
            cell = populateByArray(tableView, cellForRowAt: indexPath, array: viewModel.getUpcoming()) as! CustomTableViewCell
        }
        else{
            cell = populateByArray(tableView, cellForRowAt: indexPath, array: viewModel.getHistory()) as! CustomTableViewCell
        }
        cell.backgroundColor = UIColor(white: 1, alpha: 0.7)
        tableView.tableFooterView = UIView(frame: CGRect.zero)

        return cell
    }
    
    //helper function to populate the cell with the intended array
    func populateByArray(_ tableView:UITableView, cellForRowAt indexPath: IndexPath, array: [Flight]) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        cell.descriptionLabel.text = "one-way"
        cell.icon.image = UIImage(named: "plane-icon")
        cell.sourceLabel.text = array[indexPath.section].source
        cell.airlineLabel.text = array[indexPath.section].airline
        cell.destinationLabel.text = array[indexPath.section].destination
        cell.departureDateLabel.text = "\(array[indexPath.section].departureDate)"
        if(array[indexPath.section].returnDate != ""){
            cell.departureDateLabel.text =  "\(cell.departureDateLabel.text ?? "") | \(array[indexPath.section].returnDate)"
            cell.icon.image = UIImage(named: "two-way-icon")
            cell.descriptionLabel.text = "two-way"
        }
        cell.layer.cornerRadius = 8
        return cell
    }
    
    //direct each cell to another view controller to show the details
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showdetail", sender: self)
    }
    
    //pass the cell data to the view controller to show details
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PlanDetailViewController{
            let detail:Flight
           
            if(self.viewUpcoming){
                detail = viewModel.getUpcoming()[(tableView.indexPathForSelectedRow?.section)!]
            }
            else{
                detail = viewModel.getHistory()[(tableView.indexPathForSelectedRow?.section)!]
            }
            destination.detail = detail
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
        }
    }
    
    //method to remove a plan
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
//        let row: Int = indexPath.row
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            if(self.viewUpcoming){
                viewModel.removePlan(flight: viewModel.getUpcoming()[indexPath.section])
                self.updateUpcomingView()
            }
            else{
                viewModel.removePlan(flight: viewModel.getHistory()[indexPath.section])
                self.updateHistoryView()
            }
            self.tableView.reloadData()
        }
    }
    
    func updateUpcomingView(){
        if(viewModel.getUpcoming().count == 0){
            self.noPlansLabel.alpha = 1
        }
    }
    
    func updateHistoryView(){
        if(viewModel.getHistory().count == 0){
            self.noPlansLabel.alpha = 1
        }
    }
}

