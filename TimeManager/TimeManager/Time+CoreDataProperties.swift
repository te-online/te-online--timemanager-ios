//
//  Time+CoreDataProperties.swift
//  
//
//  Created by Thomas Ebert on 15.08.16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TimeObject {

    @NSManaged var changed: NSDate?
    @NSManaged var commit: String?
    @NSManaged var created: NSDate?
    @NSManaged var end: NSDate?
    @NSManaged var uuid: String?
    @NSManaged var note: String?
    @NSManaged var start: NSDate?
    @NSManaged var task_uuid: String?
    @NSManaged var task: TaskObject?

    func getDuration() -> Double {
        return 5
    }
    
    func getDurationInHours() -> Double {
        let createdComponents: NSDateComponents = NSCalendar.currentCalendar().components([.Hour, .Minute], fromDate: self.start!, toDate: self.end!, options: [])
        return (Double(createdComponents.hour) + (Double(createdComponents.minute) / 60)) ?? 0
    }
    
}
