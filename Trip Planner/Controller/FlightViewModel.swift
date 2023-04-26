//
//  FlightViewModel.swift
//  Trip Planner
//
//  Created by Ryan Liang on 5/10/20.
//  Copyright © 2020 RMIT. All rights reserved.
//

import Foundation

class FlightViewModel{
    private var model = REST_Skyscanner_flight.shared
    
    var delegate:Refresh? {
        get {
            return model.delegate
        }
        set (value) {
            model.delegate = value
        }
    }
    
    var count:Int {
        return flights.count
    }
    
    // Check for uniqueness between two lists of flights
    func unique(flights: [Flight]) -> [Flight] {
        
        var uniqueplace = [Flight]()
        
        for flight in flights {
            if !uniqueplace.contains(flight) {
                uniqueplace.append(flight)
            }
        }
        
        return uniqueplace
    }
    
    
    func resetFlights() {
        model.flights.removeAll()
    }
    
    var flights:[Flight]{
        return model.flights
    }

    // Rest API call to get the flights results using the airport codes from departure and arrival
    func getFlight(countryName:String,currency:String, location:String,airportCodeFrom:String, airportCodeTo:String,fromDate:String,toDate:String){
        model.getFlight(countryName: countryName, currency: currency, location: location, airportCodeFrom: airportCodeFrom, airportCodeTo: airportCodeTo, fromDate: fromDate, toDate: toDate)
    }
    
    
    
    
    
    
    
    
    
    
}

