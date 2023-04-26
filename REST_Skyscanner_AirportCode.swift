//
//  REST_Skyscanner_AirportCode.swift
//  Trip Planner
//
//  Created by Ryan Liang on 3/10/20.
//  Copyright © 2020 RMIT. All rights reserved.
//

import Foundation



class REST_Skyscanner_AirportCode {
    var places: [Places] = []
    var delegate: Refresh?
    
    let headers = [
        "x-rapidapi-host": "skyscanner-skyscanner-flight-search-v1.p.rapidapi.com",
        "x-rapidapi-key": "b5160ea580msh7ae96c9d60b5bc2p1e35b4jsn4850892b52cd"
    ]
    
    private let session = URLSession.shared
    
    private let base_url:String = "https://skyscanner-skyscanner-flight-search-v1.p.rapidapi.com/apiservices/autosuggest/v1.0"
    
    
    func getAirportCode(countryName:String, currency:String, place:String, location:String) {
        let url = base_url + "/" + countryName + "/" + currency + "/" + place + "/" + "?query=" + location

        guard  let escapedAddress = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)else{return}
        
        if let url = URL(string: escapedAddress) {
            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = headers
            getData(request, element: "results")
        }
        
    }
    
    private func getData(_ request: URLRequest, element: String) {
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
                if (result["message"] != nil || result["ValidationErrors"] != nil){
                    return
                }
                let results = result["Places"] as! [[String:Any]]
                
                if results.count > 0
                {
                    for r in results
                    {
                        let placeId = r["PlaceId"] as! String
                        let placeName = r["PlaceName"] as! String
                        let countryId = r["CountryId"] as! String
                        let regionId = r["RegionId"] as! String
                        let cityId = r["CityId"] as! String
                        let countryName = r["CountryName"] as! String
                        let place = Places(placeId: placeId,placeName:placeName, countryId:countryId, regionId:regionId, cityId:cityId, countryName:countryName)
                        self.places.append(place)
                    }
                }
                
                DispatchQueue.main.async(execute:{
                    self.delegate?.updateUI()
                })
            }
        }
    )
        task.resume()
    }
    
    
    private init(){}
    static let shared = REST_Skyscanner_AirportCode()
    
    
}

