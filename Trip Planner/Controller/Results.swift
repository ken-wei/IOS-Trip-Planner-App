//
//  Results.swift
//  Trip Planner
//
//  Created by Ryan Liang on 24/8/20.
//  Copyright © 2020 RMIT. All rights reserved.
//

import Foundation

struct Results{
    private var results = [Flight]()
    
    init(){
    }
    
    func getCertainResults(departureCity:String,arrivalCity:String)->[Flight]{
        var certainFlights = [Flight]()
        for result in results {
            if (departureCity == result.source && arrivalCity == result.destination ) {
                certainFlights.append(result)
            }
        }
         return certainFlights
    }
   
}
