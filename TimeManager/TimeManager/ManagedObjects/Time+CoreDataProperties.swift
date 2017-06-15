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

    @NSManaged var changed: Date?
    @NSManaged var commit: String?
    @NSManaged var created: Date?
    @NSManaged var end: Date?
    @NSManaged var uuid: String?
    @NSManaged var note: String?
    @NSManaged var start: Date?
    @NSManaged var task_uuid: String?
    @NSManaged var task: TaskObject?
    
    func getDurationInHours() -> Double {
        let createdComponents: DateComponents = (Calendar.current as NSCalendar).components([.hour, .minute], from: self.start!, to: self.end!, options: [])
        return (Double(createdComponents.hour!) + (Double(createdComponents.minute!) / 60)) ?? 0
    }
    
    func getHoursString() -> String {
        return FormattingHelper.formatHoursAsString(self.getDurationInHours())
    }
    
    func getDateString() -> String {
        return FormattingHelper.dateFormat(.daynameDayMonthnameYear, date: self.start!) // "Mon 19. August 2001"
    }
    
    // Returns a string describing the timespan the entry covers. E.g. 12.00 – 14.00
    func getTimeSpanString() -> String {
        return String(format: "%@ – %@", FormattingHelper.dateFormat(.hoursMinutes, date: self.start!), FormattingHelper.dateFormat(.hoursMinutes, date: self.end!))  // "12.00 – 14.00"
    }
    
    func toJSON() -> Dictionary<String, AnyObject> {
        return [
            "uuid": self.uuid as AnyObject ?? "" as AnyObject,
            "task_uuid": self.task_uuid as AnyObject ?? "" as AnyObject,
            "start": FormattingHelper.dateFormat(.isoString, date: self.start!),
            "end": FormattingHelper.dateFormat(.isoString, date: self.end!),
            "note": self.note ?? "",
            "commit": self.commit ?? "",
            "created": FormattingHelper.dateFormat(.isoString, date: self.created!),
            "changed": FormattingHelper.dateFormat(.isoString, date: self.changed!)
        ]
    }
    
}
