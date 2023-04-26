//
//  ModelController.swift
//  Trip Planner
//
//  Created by Ken Wei Ooi on 26/08/2020.
//  Copyright © 2020 RMIT. All rights reserved.
//

import Foundation

// Dependency Injection
class ModelController {
    var resultsViewModel: ResultsViewModel!
    var planViewModel: PlanViewModel!
    var flightViewModel: FlightViewModel!
    init() {
        resultsViewModel = ResultsViewModel()
        planViewModel = PlanViewModel()
        flightViewModel = FlightViewModel()
    }
}
