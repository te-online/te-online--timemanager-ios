//
//  TimeTraveller.swift
//  TimeManager
//
//  Created by Thomas Ebert on 16.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit
import CoreData

class TimeTraveller {
    
    var dataController: AppDelegate! = UIApplication.sharedApplication().delegate as! AppDelegate
    
    func todaysRecordedHours() -> Double {
        NSLog("Here we go...")
        // Find all time entries from today and sum up hours
        let today = NSDate()

        let todayBeginComponents: NSDateComponents = NSCalendar.currentCalendar().components([.Day,.Month,.Year], fromDate: today)
        todayBeginComponents.hour = 0
        todayBeginComponents.minute = 0
        todayBeginComponents.second = 0
        
        let todayBegin = NSCalendar.currentCalendar().dateFromComponents(todayBeginComponents)
        
        let todayEndComponents: NSDateComponents = NSCalendar.currentCalendar().components([.Day,.Month,.Year], fromDate: today)
        todayEndComponents.hour = 23
        todayEndComponents.minute = 59
        todayEndComponents.second = 59
        
        let todayEnd = NSCalendar.currentCalendar().dateFromComponents(todayEndComponents)

        let request = NSFetchRequest(entityName: "Time")
        
        let createdSort = NSSortDescriptor(key: "created", ascending: true)
        request.sortDescriptors = [createdSort]
        
        let forToday = NSPredicate(format: "(start >= %@) AND (start <= %@)", todayBegin!, todayEnd!)
        request.predicate = forToday
        
        let moc = self.dataController.managedObjectContext
        
        var hoursCount: Double = 0
        
        do {
            let entries = try moc.executeFetchRequest(request)
            if entries.count > 0 {
                for entry in entries {
                    hoursCount += (entry as! TimeObject).getDurationInHours()
                }
            }
            NSLog("Entries " + String(entries))
        } catch {
            fatalError("Failed to execute fetch request for todays hours: \(error)")
        }
        
        return hoursCount

    }
    
    func thisWeeksRecordedHours() -> Double {
        // Determine all days in this week
        // Repeat todaysRecordedHours for each day and sum up hours
        return 37.5
    }
    
    func fiveMostRecentEntries() {
        // Get the five most recent time entries by creation date
    }
    
    func recordedHoursForDayInProject(day: NSDate, project: ProjectObject) -> Double {
        // Get all entries for project and given date and sum up
        return 10.5
    }
    
}
