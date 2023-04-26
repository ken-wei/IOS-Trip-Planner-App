//
//  FlightInfoViewController.swift
//  Trip Planner
//
//  Created by Ryan Liang on 24/8/20.
//  Copyright © 2020 RMIT. All rights reserved.
//

import UIKit
class FlightInfoViewController: UIViewController,Refresh {
    var modelController: ModelController!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var noResultLabel: UILabel!
    // Dates from home view
    var departureDate:String = ""
    var returnDate:String = ""
    
    // Cities from home view
    var departureCity:String = ""
    var arrivalCity:String = ""
    var currency:String = ""
    
    var oneWay:Bool = false
    let backgroundImage = UIImage(named: "background2.png")
    var placesFrom = [Places]()
    var placesTo = [Places]()
    let cellSpacingHeight: CGFloat = 5
    var flights = [Flight]()
    
    // Variables passed from HomeViewControll
    var arrivalCountryFN:String = ""
    var arrivalCountrySN:String = ""
    var departureCountryFN:String = ""
    var departureCountrySN:String = ""
    
    // Variables to check when to update the UI
    var citiesUpdated:Bool = false
    var flightsUpdated:Bool = false
    var places:[Places] = []
    
    // Results for table to update
    var results = [Flight]()
    
    weak var homeView: HomeViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        homeView.modelController.resultsViewModel.delegate = self
        homeView.modelController.flightViewModel.delegate = self
        tableView.dataSource = self
        self.tableView.rowHeight = 150.0
        let imageView = UIImageView(image: backgroundImage)
        let nib = UINib(nibName: "FlightCustomTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "FlightCustomTableViewCell")
        self.tableView.backgroundView = imageView

        if(returnDate == ""){
            oneWay = true
        }
        self.noResultLabel.layer.backgroundColor = UIColor(white:1,alpha:0.7).cgColor
        self.noResultLabel.layer.cornerRadius = 8
        self.noResultLabel.alpha = 0;
        self.tableView.backgroundColor = UIColor.clear
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Reset places and flights from the viewmodel everything users come from home page
        homeView.modelController.resultsViewModel.resetPlaces()
        homeView.modelController.flightViewModel.resetFlights()
        
        homeView.modelController.resultsViewModel.getDepartureAirportCode(countryName: departureCountrySN, currency: currency, place: "en-GB", location: departureCity)
        homeView.modelController.resultsViewModel.getDepartureAirportCode(countryName: arrivalCountrySN, currency: currency, place: "en-GB", location: arrivalCity)
        
        // Update the boolean variables each time this view appears
        self.citiesUpdated = true
        self.flightsUpdated = false
        // Reset places
        self.placesFrom.removeAll()
        self.placesTo.removeAll()
        
    }
    
    // Refresh Protocol
    func updateUI() {
        
        // To check if users have entered new cities for departure and arrival using model places
        if self.citiesUpdated {
            self.places = homeView.modelController.resultsViewModel.places
            for x in 0..<self.places.count{
                if (self.places[x].countryName == departureCountryFN && self.places[x].placeName.contains(departureCity)){
                    
                    self.placesFrom.append(places[x])
                }
                if (self.places[x].countryName == arrivalCountryFN && self.places[x].placeName.contains(arrivalCity) ){
                    self.placesTo.append(places[x])
                }
            }
        }
        
        // Check if all cities places api response are returned
        if (self.placesTo.count > 0 && self.placesFrom.count > 0) {
            // Update cities boolean after all data are loaded
            self.citiesUpdated = false
        }
        
        // Calling the flights api from each airportcode of departure to each airportcode of arrival
        if (self.placesTo.count > 0 && self.placesFrom.count > 0 && !self.flightsUpdated) {
            for x in 0..<self.placesFrom.count{
                for y in 0..<self.placesTo.count{
                    homeView.modelController.flightViewModel.getFlight(countryName: departureCountrySN, currency: currency, location: "en-US", airportCodeFrom: self.placesFrom[x].placeId, airportCodeTo: self.placesTo[y].placeId, fromDate: departureDate, toDate: returnDate)
                }
            }
            self.flightsUpdated = true
        }
        
        // Update the results to display (to not have repeating flight results)
        self.flights = homeView.modelController.flightViewModel.flights
        self.results = homeView.modelController.flightViewModel.unique(flights: self.flights)
      
        // If all flights are updated then reload the data inside the table view
        if self.flightsUpdated {
            tableView.reloadData()
            if(results.count > 0){
                self.noResultLabel.alpha = 0
            }
            else{
                self.noResultLabel.alpha = 1
            }
        }
        

    }
    

    //function to create alert for the user
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension FlightInfoViewController: UITableViewDelegate{
}

//give number of cell by results array size
extension FlightInfoViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.results.count
    }
    
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

    
    //populate cell with data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {

        let cell = tableView.dequeueReusableCell(withIdentifier: "FlightCustomTableViewCell", for: indexPath) as! FlightCustomTableViewCell
        cell.sourceLabel.text =  results[indexPath.section].source
        cell.arrivalLabel.text =  results[indexPath.section].destination
        
        
        //assign the label if the flight search is one-way
        if(self.oneWay){
            cell.flightIcon.image = UIImage(named: "plane-icon")
            cell.dateLabel.text = results[indexPath.section].departureDate
            results[indexPath.section].departureDate = results[indexPath.section].departureDate
            cell.descriptionLabel.text = "one-way"
            cell.flightResult = results[indexPath.section]
            cell.flightResult.returnDate = ""
        }
        //assign the label if the flight search is two-way
        else{
            cell.flightIcon.image = UIImage(named: "two-way-icon")
            cell.dateLabel.text = results[indexPath.section].departureDate+" | "+results[indexPath.section].returnDate
            results[indexPath.section].departureDate = results[indexPath.section].departureDate
            cell.descriptionLabel.text = "two-way"
            results[indexPath.section].returnDate = results[indexPath.section].returnDate
            cell.flightResult = results[indexPath.section]
        }
        
        cell.airlineLabel.text = results[indexPath.section].airline
        cell.flightResult.price = "\(currency) \(results[indexPath.section].price).00"
        cell.priceLabel.text = cell.flightResult.price 
        cell.parentView = self
        
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.backgroundColor = UIColor(white: 1, alpha: 0.7)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        cell.layer.cornerRadius = 8
        
        
        
        return cell
    }
    
}

