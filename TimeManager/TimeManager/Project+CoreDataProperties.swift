//
//  Project+CoreDataProperties.swift
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

extension ProjectObject {

    @NSManaged var changed: NSDate?
    @NSManaged var client_uuid: String?
    @NSManaged var color: String?
    @NSManaged var commit: String?
    @NSManaged var created: NSDate?
    @NSManaged var uuid: String?
    @NSManaged var name: String?
    @NSManaged var note: String?
    @NSManaged var client: ClientObject?
    @NSManaged var tasks: NSSet?
    
    func getTotalHours() -> Double {
        var totalHours: Double = 0
        
        if tasks != nil {
            for task in self.tasks! {
                totalHours = totalHours + (task as! TaskObject).getTotalHours()
            }
        }
        
        return totalHours
    }
    
    func getNumberOfTasks() -> Int {
        if self.tasks != nil {
            return self.tasks!.count
        }
        
        return 0
    }
    
    func getMetaString() -> String {
        var metaString = self.getNumberOfTasksString()
        metaString = metaString + " • "
        
        metaString = metaString + self.getTotalHoursString()
        
        return metaString
    }
    
    func getNumberOfTasksString() -> String {
        return FormattingHelper.formatSomeNumberWithUnit(self.getNumberOfTasks(), unitSingular: "task", unitPlural: "tasks")
    }
    
    func getTotalHoursString() -> String {
        return FormattingHelper.formatHoursAsString(self.getTotalHours())
    }

}
