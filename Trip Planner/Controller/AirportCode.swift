//
//  AirportCode.swift
//  Trip Planner
//
//  Created by Ryan Liang on 24/8/20.
//  Copyright © 2020 RMIT. All rights reserved.
//

import Foundation

enum AirportCode : String {
    case Melbourne = "MEL"
    case Sydney = "SYD"
    case Adelaide = "ADL"
    case Perth = "PER"
    case Canberra = "CBR"
}


struct Places:Equatable{
    var placeId:String
    var placeName:String
    var countryId:String
    var regionId:String
    var cityId:String
    var countryName:String
}
