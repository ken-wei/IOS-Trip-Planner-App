//
//  Plan.swift
//  Trip Planner
//
//  Created by Jeremy Kane on 8/20/20.
//  Copyright © 2020 RMIT. All rights reserved.
//

import Foundation

// struct to store flight information
struct PlaceCode:Equatable{
    var placeName:String
    var code:String
    init(placeName:String, code:String) {
        self.placeName = placeName
        self.code = code
    }
}

struct Flight:Equatable{
    var source:String
    var destination:String
    var departureDate:String
    var price:String
    var returnDate:String
    var direct:String
    var sourceToDestination:String
    var dateInDateFormat:Date
    var airline:String
    var note:String
    
    init(sourceToDestination:String, departureDate:String, price:String, returnDetail:[String], direct:Bool, note:String = "", airline:String){
        self.sourceToDestination = sourceToDestination
        let fullStringArr = sourceToDestination.split{$0 == "-"}.map(String.init)
        self.source = fullStringArr[0]
        self.destination = fullStringArr[1]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        self.departureDate = departureDate
        self.dateInDateFormat = dateFormatter.date(from: departureDate)!
        self.price = price
        self.airline = airline
        if(returnDetail.count>0){
            self.returnDate = returnDetail[0]
        }
        else{
            self.returnDate = ""
        }
        
        if(direct){
            self.direct = "Direct"
        }
        else{
            self.direct = "Transit"
        }
        self.note = note
    }
}

