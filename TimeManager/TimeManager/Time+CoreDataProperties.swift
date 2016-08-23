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
    
    func getDurationInHours() -> Double {
        let createdComponents: NSDateComponents = NSCalendar.currentCalendar().components([.Hour, .Minute], fromDate: self.start!, toDate: self.end!, options: [])
        return (Double(createdComponents.hour) + (Double(createdComponents.minute) / 60)) ?? 0
    }
    
    func getHoursString() -> String {
        return FormattingHelper.formatHoursAsString(self.getDurationInHours())
    }
    
    func getDateString() -> String {
        return FormattingHelper.dateFormat(.DaynameDayMonthnameYear, date: self.start!) // "Mon 19. August 2001"
    }
    
    func getTimeSpanString() -> String {
        return String(format: "%@ – %@", FormattingHelper.dateFormat(.HoursMinutes, date: self.start!), FormattingHelper.dateFormat(.HoursMinutes, date: self.end!))  // "12.00 – 14.00"
    }
    
    func toJSON() -> Dictionary<String, AnyObject> {
        return [
            "uuid": self.uuid ?? "",
            "task_uuid": self.task_uuid ?? "",
            "start": FormattingHelper.getISOStringFromDate(self.start!),
            "end": FormattingHelper.getISOStringFromDate(self.end!),
            "note": self.note ?? "",
            "commit": self.commit ?? "",
            "created": FormattingHelper.getISOStringFromDate(self.created!),
            "changed": FormattingHelper.getISOStringFromDate(self.changed!)
        ]
    }
    
}
