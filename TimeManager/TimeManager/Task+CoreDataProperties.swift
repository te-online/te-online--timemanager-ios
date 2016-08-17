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

    @NSManaged var changed: NSDate?
    @NSManaged var commit: String?
    @NSManaged var created: NSDate?
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
            "uuid": self.uuid ?? "",
            "name": self.name ?? "",
            "project_uuid": self.project_uuid ?? "",
            "commit": self.commit ?? "",
            "created": FormattingHelper.getISOStringFromDate(self.created!),
            "changed": FormattingHelper.getISOStringFromDate(self.changed!)
        ]
    }
    
}
