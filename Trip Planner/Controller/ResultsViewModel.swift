//
//  ResultsViewModel.swift
//  Trip Planner
//
//  Created by Ryan Liang on 24/8/20.
//  Copyright © 2020 RMIT. All rights reserved.
//

import Foundation

class ResultsViewModel{
    private var results:Results = Results()
    
    
    private var model = REST_Skyscanner_AirportCode.shared
    
   
    
    
    var delegate:Refresh? {
        get {
            return model.delegate
        }
        set (value) {
            model.delegate = value
        }
    }

    var count:Int {
        return places.count
    }
    
    var places:[Places]
    {
        return model.places
    }
    
    func resetPlaces() {
        model.places.removeAll()
    }
    
    func unique(places: [Places]) -> [Places] {
        
        var uniqueplace = [Places]()
        
        for place in places {
            if !uniqueplace.contains(place) {
                uniqueplace.append(place)
            }
        }
        
        return uniqueplace
    }
    
    func getDepartureAirportCode(countryName:String, currency:String, place:String, location:String)
    {
         model.getAirportCode(countryName: countryName, currency: currency, place:place, location:location)
    }
    

    
    func getResults(departureCity: String, arrivalCity: String)->[Flight]{
        return results.getCertainResults(departureCity: departureCity,arrivalCity: arrivalCity)
    }
}
