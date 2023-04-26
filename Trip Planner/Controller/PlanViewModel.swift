//
//  PlanViewModel.swift
//  Trip Planner
//
//  Created by Jeremy Kane on 8/21/20.
//  Copyright © 2020 RMIT. All rights reserved.
//

import Foundation

class PlanViewModel{
    
    private var plans:Plans = Plans()
    
    func getHistory()->[Flight]{
        return plans.getHistoryPlans()
    }
    
    func getUpcoming()->[Flight]{
        return plans.getUpcomingPlans()
    }
    
    func removePlan(flight:Flight){
        plans.removePlan(flight: flight)
    }
    
    func addPlan(flight: Flight) {
        plans.addPlan(flight: flight)
        plans.sortPlansByDate()
    }
    
    func checkExistence(flight: Flight)->Bool{
        return plans.checkExistence(flight: flight)
    }
    
    func updateNote(flight: Flight,text: String){
        return plans.updateNote(flight: flight,text: text)
    }
}
