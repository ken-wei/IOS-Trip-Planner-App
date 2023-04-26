//
//  REST_Skyscanner_flight.swift
//  Trip Planner
//
//  Created by Ryan Liang on 5/10/20.
//  Copyright © 2020 RMIT. All rights reserved.
//

import Foundation

protocol RefreshFlightsAndPlaces {
    func updatePlaces()
    func updateFlights()
}

class REST_Skyscanner_flight{
    var flights:[Flight] = []
    var iatacode:[PlaceCode] = []
    var delegate: Refresh?
    
    let headers = [
        "x-rapidapi-host": "skyscanner-skyscanner-flight-search-v1.p.rapidapi.com",
        "x-rapidapi-key": "b5160ea580msh7ae96c9d60b5bc2p1e35b4jsn4850892b52cd"
    ]
    
    private let session = URLSession.shared
    
    private let base_url:String = "https://skyscanner-skyscanner-flight-search-v1.p.rapidapi.com/apiservices/browsequotes/v1.0"
    
    func getFlight(countryName:String,currency:String, location:String,airportCodeFrom:String, airportCodeTo:String,fromDate:String,toDate:String){
        
        let url = base_url + "/" + countryName + "/" + currency + "/" + location + "/" + airportCodeFrom + "/" + airportCodeTo + "/" + fromDate + "/" + toDate
        
        guard  let escapedAddress = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)else{return}
        
        if let url = URL(string: escapedAddress) {
            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = headers
            
            getData(request, element: "results")
        }
    }
    
    private func getData(_ request: URLRequest, element: String){
        let task = session.dataTask(with: request, completionHandler: {
            data, response, downloadError in
            
            if let error = downloadError
            {
                print(error)
            }
            else
            {
                var parsedResult: Any! = nil
                do
                {
                    parsedResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                }
                catch{
                    print()
                }
                
                let result = parsedResult as! [String:Any]
                // If there's any validation error or BASIC plan limit exceeded return
                if (result["message"] == nil && result["ValidationErrors"] == nil)
                {
                        let resultQuotes = result["Quotes"] as! [[String:Any]]
                        let resultPlaces = result["Places"] as! [[String:Any]]
                    
                        if (resultQuotes.count > 0){
                            for x in 0..<resultQuotes.count{
                                let resultOutboundLeg = resultQuotes[x]["OutboundLeg"] as! [String:Any]
                                let resultInboundLeg = resultQuotes[x]["InboundLeg"] as? [String:Any]
                                let airlineData = resultOutboundLeg["CarrierIds"] as! NSArray
                                var airline = ""
                                let carriers = result["Carriers"] as! NSArray
                                for x in carriers{
                                    let airlineDictionary = x as! NSDictionary
                                    let airlineCode = airlineData[0] as! Int
                                    let carrierId = airlineDictionary["CarrierId"] as! Int
                                    if (airlineCode == carrierId){
                                        airline = airlineDictionary["Name"] as! String
                                    }
                                }
                                var check = false
                                if (resultInboundLeg?.count ?? 0>0){

                                    let source = resultOutboundLeg["OriginId"] as! Int
                                    let destination = resultOutboundLeg["DestinationId"] as! Int
                                    let departureDate = resultOutboundLeg["DepartureDate"] as! String
                                   
                                    let priceInt = resultQuotes[x]["MinPrice"] as! Int
                                    
                                    let price = String(priceInt)
                                    let returnDate = resultInboundLeg?["DepartureDate"] as! String
                                    let direct = resultQuotes[x]["Direct"] as! Bool
                                    let index = departureDate.index(departureDate.endIndex, offsetBy: -9)
                                    let departureDatetime = departureDate[..<index]
                                    let returnDateTime = returnDate[..<index]
                                    
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "yyyy-MM-dd"
                                    let DateString:String = String(departureDatetime)
                                    print (DateString)
                                    let toDateString = dateFormatter.date(from: DateString)!
                                    
                                    dateFormatter.dateFormat = "dd MMM yyyy"
                                    let toDateString2 = dateFormatter.string(from: toDateString)
                                    print (toDateString2)
                                    
                                    
                                    let DateString2:String = String(returnDateTime)
                                    dateFormatter.dateFormat = "yyyy-MM-dd"
                                    let toDateString3 = dateFormatter.date(from: DateString2)!
                                    dateFormatter.dateFormat = "dd MMM yyyy"
                                    let toDateString4 = dateFormatter.string(from: toDateString3)
                                    print(toDateString4)
                                
                                    
                                    var sourceName:String = ""
                                    var desName:String = ""
                                    var sourceCode:String = ""
                                    var desCode:String = ""
                                    if (resultPlaces.count > 0){
                                        for i in 0..<resultPlaces.count{
                                            let placeId = resultPlaces[i]["PlaceId"]! as! Int
                                            if (String(source).contains(String(placeId))){
                                                sourceName = resultPlaces[i]["IataCode"] as! String
                                                sourceCode = resultPlaces[i]["IataCode"] as! String
                                                self.iatacode.append(PlaceCode(placeName:sourceName, code: sourceCode))
                                            }
                                            if (String(destination).contains(String(placeId))){
                                                desName = resultPlaces[i]["IataCode"] as! String
                                                desCode = resultPlaces[i]["IataCode"] as! String
                                                self.iatacode.append(PlaceCode(placeName:desName, code: desCode))
                                            }
                                        }
                                    }
                                    
                                    
                                    
                                    let sourceString = String(sourceName)
                                    let destinationString = String(desName)
                                    let sourceToDestination = sourceString+"-"+destinationString
                                    
                                    self.flights.append(Flight(sourceToDestination: sourceToDestination, departureDate: String(toDateString2), price: price, returnDetail: [String(toDateString4)], direct: direct, airline: airline))
                                    
                                    check = true
                                }
                                if (check == false) {
                                    let source = resultOutboundLeg["OriginId"] as! Int
                                    let destination = resultOutboundLeg["DestinationId"] as! Int
                                    let departureDate = resultOutboundLeg["DepartureDate"] as! String
                                    let price = resultQuotes[x]["MinPrice"] as! Int
                                    let direct = resultQuotes[x]["Direct"] as! Bool
                                    let index = departureDate.index(departureDate.endIndex, offsetBy: -9)
                                    let  departureDatetime = departureDate[..<index]
                                    
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "yyyy-MM-dd"
                                    let DateString:String = String(departureDatetime)
                                    let toDateString = dateFormatter.date(from: DateString)!
                                    
                                    dateFormatter.dateFormat = "dd MMM yyyy"
                                    let toDateString2 = dateFormatter.string(from: toDateString)
                                    
                                    var sourceName:String = ""
                                    var desName:String = ""
                                    var sourceCode:String = ""
                                    var desCode:String = ""
                                    if (resultPlaces.count > 0){
                                        for i in 0..<resultPlaces.count{
                                            let placeId = resultPlaces[i]["PlaceId"]! as! Int
                                            if (String(source).contains(String(placeId))){
                                                sourceName = resultPlaces[i]["IataCode"] as! String
                                                sourceCode = resultPlaces[i]["IataCode"] as! String
                                                self.iatacode.append(PlaceCode(placeName:sourceName, code: sourceCode))
                                            }
                                            if (String(destination).contains(String(placeId))){
                                                desName = resultPlaces[i]["IataCode"] as! String
                                                desCode = resultPlaces[i]["IataCode"] as! String
                                                self.iatacode.append(PlaceCode(placeName:desName, code: desCode))
                                            }
                                        }
                                    }
                                    
                                    
                                    let sourceString = String(sourceName)
                                    let destinationString = String(desName)
                                    let sourceToDestination = sourceString+"-"+destinationString
                                    self.flights.append(Flight(sourceToDestination: sourceToDestination, departureDate: String(toDateString2), price: String(price), returnDetail: [], direct: direct, airline: airline))
                                    
                                }
                               
                            }
                        }
                }
                
                DispatchQueue.main.async(execute:{
                    self.delegate?.updateUI()
                })
            }
            
        })
        
        task.resume()
    }
    
    private init(){}
    static let shared = REST_Skyscanner_flight()

}
