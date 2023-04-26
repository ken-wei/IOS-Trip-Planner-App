//
//  CurrencyViewModel.swift
//  Trip Planner
//
//  Created by Ken Wei Ooi on 02/10/2020.
//  Copyright © 2020 RMIT. All rights reserved.
//

import Foundation

struct CurrencyViewModel {
    
    private var model = REST_Skyscanner_currency.shared
    
    var delegate:Refresh? {
        get {
            return model.delegate
        }
        set (value) {
            model.delegate = value
        }
    }
    
    var count:Int {
        return currencies.count
    }
    
    var currencies:[String] {
        return model.currencies
    }
    
    // Actual REST API call to get all currencies from SKYSCANNER API
    func getAllCurrencies() {
        model.getAllCurrency()
    }
    
    // Get currency from country code
    func getCurrencyFromCountryCode(country_code: String) -> String? {
        let localeIds = Locale.availableIdentifiers
        var countryCurrency = [String: String]()
        for localeId in localeIds {
            let locale = Locale(identifier: localeId)
            
            if let country = locale.regionCode, country.count == 2 {
                if let countryName = locale.localizedString(forRegionCode: country) {
                    if let currency = locale.currencyCode {
                        countryCurrency[countryName] = currency
                    }
                }
                
            }
        }
        
        return countryCurrency[country_code]!
    }
    
}
