//
//  REST_Skyscanner_currency.swift
//  Trip Planner
//
//  Created by Ken Wei Ooi on 02/10/2020.
//  Copyright © 2020 RMIT. All rights reserved.
//

import Foundation

protocol Refresh {
    func updateUI()
}

class REST_Skyscanner_currency {
    
    // Array of all currency from the request
    private var _currencies:[String] = []
    var delegate:Refresh?
    
    let headers = [
        "x-rapidapi-host": "skyscanner-skyscanner-flight-search-v1.p.rapidapi.com",
        "x-rapidapi-key": "76a5a70cb6msh2275a6e85d3ba0dp1ed0a2jsn2d38f62c123f"
    ]
    
    private let session = URLSession.shared
    
    private let base_url:String = "https://skyscanner-skyscanner-flight-search-v1.p.rapidapi.com/apiservices/reference/v1.0/currencies"
    
    var currencies:[String] {
        return _currencies
    }

    
    func getAllCurrency() {
        guard let escapedAddress =  base_url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            else {return}
        if let url = URL(string: escapedAddress) {
            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = headers
            getData(request, element: "Currencies")
        }
    }
    
    private func getData(_ request: URLRequest, element: String) {
        let task = session.dataTask(with: request,
            completionHandler: {
                data, reponse, downloadError in
                
                if let error = downloadError {
                    print(error)
                }
                else {
                    var parsedResult: Any! = nil
                    do {
                        parsedResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    } catch { print() }
                    let result = parsedResult as! [String:Any]
                    
                    // If there's any validation error or BASIC plan limit exceeded return
                    if result["message"] != nil {
                        return
                    }
                    let allCurrencies = result["Currencies"] as! [[String: Any]]
                    
                    if allCurrencies.count > 0 {
                        for currency in allCurrencies {
                            self._currencies.append(currency["Code"] as! String)
                        }
                    }
                    DispatchQueue.main.async {
                        self.delegate?.updateUI()
                    }
                }
            
        })
        
        task.resume()
    }
    
    private init(){}
    static let shared = REST_Skyscanner_currency()
}
