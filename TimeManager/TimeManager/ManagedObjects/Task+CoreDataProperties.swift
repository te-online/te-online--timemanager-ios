//
//  Task+CoreDataProperties.swift
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

extension TaskObject {

    @NSManaged var changed: Date?
    @NSManaged var commit: String?
    @NSManaged var created: Date?
    @NSManaged var uuid: String?
    @NSManaged var name: String?
    @NSManaged var project_uuid: String?
    @NSManaged var project: ProjectObject?
    @NSManaged var times: NSSet?

    func getTotalHours() -> Double {
        var totalHours: Double = 0
        
        if times != nil {
            for time in self.times! {
                totalHours = totalHours + (time as! TimeObject).getDurationInHours()
            }
        }
        
        return totalHours
    }
    
    func getTotalHoursString() -> String {
        return FormattingHelper.formatHoursAsString(self.getTotalHours())
    }
    
    func toJSON() -> Dictionary<String, AnyObject> {
        return [
            "uuid": self.uuid as AnyObject ?? "" as AnyObject,
            "name": self.name as AnyObject ?? "" as AnyObject,
            "project_uuid": self.project_uuid as AnyObject ?? "" as AnyObject,
            "commit": self.commit as AnyObject ?? "" as AnyObject,
            "created": FormattingHelper.dateFormat(.isoString, date: self.created!) as AnyObject,
            "changed": FormattingHelper.dateFormat(.isoString, date: self.changed!) as AnyObject
        ]
    }
    
}
