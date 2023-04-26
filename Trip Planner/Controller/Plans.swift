//
//  Plans.swift
//  Trip Planner
//
//  Created by Jeremy Kane on 8/24/20.
//  Copyright © 2020 RMIT. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Plans{
    private var plans = [Flight]()
    
    //initialize struct
    init(){
    }
    
    //adding a plan from the search result
    func addPlan(flight: Flight){
//        sortPlansByDate()
        // refer to Appdelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        // create a context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // entity for new record
        let planEntity = NSEntityDescription.entity(forEntityName: "Plan", in:managedContext)
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Plan")
        
        fetchRequest.predicate = NSPredicate(format: "sourceToDestination = %@ AND departureDate = %@ AND airline = %@ AND price = %d", flight.sourceToDestination, flight.departureDate , flight.airline, flight.price)
        
        do{
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            if(result.count == 0){
                let plan = NSManagedObject(entity: planEntity!, insertInto: managedContext)
                
                print(flight.sourceToDestination)
                plan.setValue(flight.sourceToDestination, forKey: "sourceToDestination")
                plan.setValue(flight.departureDate, forKey: "departureDate")
                plan.setValue(flight.price, forKey: "price")
                plan.setValue([flight.returnDate], forKey: "returnDetail")
                plan.setValue([flight.direct], forKey: "direct")
                plan.setValue(flight.airline, forKey: "airline")
                plan.setValue("", forKey: "note")
                
                do{
                    try managedContext.save()
                    plans.insert(flight, at: 0)
                }catch let error as NSError{
                    print(error)
                }
            }
            else{
                
            }
        }catch let(e){
            print(e)
        }
    }
    
    // sort method is not stable and not working all the time
    func sortPlansByDate(){
        plans.sort(by: {$0.dateInDateFormat < $1.dateInDateFormat})
    }
    
    // removing plan function
    func removePlan(flight:Flight){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        // fetch data to delete
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Plan")//
        
        fetchRequest.predicate = NSPredicate(format: "sourceToDestination = %@ AND departureDate = %@ AND airline = %@ AND price = %@", flight.sourceToDestination, flight.departureDate , flight.airline, flight.price)
        do{
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            managedContext.delete(result[0])
            try managedContext.save()
            fetchPlan()

        }catch let e{
            print(e)
        }
        
    }
    
    func fetchPlan(){
        plans.removeAll()
        // refer to Appdelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        // create a context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // fetch data
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Plan")
        
        do{
            
        let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
        
        for i in 0 ..< result.count{
            let data = Flight(sourceToDestination: result[i].value(forKey: "sourceToDestination") as! String, departureDate: result[i].value(forKey: "departureDate") as! String, price: result[i].value(forKey: "price")  as! String, returnDetail: result[i].value(forKey: "returnDetail") as! [String], direct: true, note: result[i].value(forKey: "note") as! String, airline: result[i].value(forKey: "airline")as! String )
            plans.append(data)
            sortPlansByDate()
        }
            
        }catch let e{
            print(e)
        }
    }
    
    // return the history plan array
    func getHistoryPlans()->[Flight]{
        var historyPlans = [Flight]()
        for plan in plans{
            let dateInString = plan.departureDate
            let today = Date().addingTimeInterval(-86400)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            let date = dateFormatter.date(from:dateInString)!
            if(date < today){
                historyPlans.append(plan)
            }
        }
        fetchPlan()
        return historyPlans
    }
    
    // return the upcoming plan array
    func getUpcomingPlans()->[Flight]{
        var upcomingPlans = [Flight]()
        for plan in plans{
            let dateInString = plan.departureDate
            print ("test")
            print (dateInString)
            let today = Date().addingTimeInterval(-86400)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            let date = dateFormatter.date(from:dateInString)!
            if(date >= today){
                upcomingPlans.append(plan)
            }
        }
        fetchPlan()
        return upcomingPlans
    }
    
    //check existence of plan
    func checkExistence(flight: Flight)->Bool{
        for x in 0..<plans.count{
            if(plans[x].source == flight.source && plans[x].destination == flight.destination && plans[x].departureDate == flight.departureDate&&plans[x].price == flight.price){
                return true
            }
        }
        return false
    }
    
    func updateNote(flight: Flight, text: String){
        print(text)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        // fetch data to delete
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Plan")//
        
        fetchRequest.predicate = NSPredicate(format: "sourceToDestination = %@ AND departureDate = %@ AND airline = %@ AND price = %@", flight.sourceToDestination, flight.departureDate , flight.airline, flight.price)
        do{
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            let updateObject = result[0]
            updateObject.setValue(text, forKey: "note")
            try managedContext.save()
            fetchPlan()
            
        }catch let e{
            print(e)
        }
        
    }
}
