//
//  ClientObject+CoreDataProperties.swift
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

extension ClientObject {

    @NSManaged var changed: NSDate?
    @NSManaged var city: String?
    @NSManaged var commit: String?
    @NSManaged var created: NSDate?
    @NSManaged var email: String?
    @NSManaged var uuid: String?
    @NSManaged var name: String?
    @NSManaged var note: String?
    @NSManaged var phone: String?
    @NSManaged var postcode: String?
    @NSManaged var street: String?
    @NSManaged var web: String?
    @NSManaged var contacts: NSSet?
    @NSManaged var projects: NSSet?
    
    func getNumberOfProjects() -> Int {
        if self.projects != nil {
            return self.projects!.count
        }
        
        return 0
    }
    
    func getTotalHours() -> Double {
        var totalHours: Double = 0
        
        if self.projects != nil {
            for project in self.projects! {
                totalHours = totalHours + (project as! ProjectObject).getTotalHours()
            }
        }

        return totalHours
    }
    
    func getCreationYear() -> Int {
        return FormattingHelper.getYearFromDate(self.created!)
    }
    
    func getMetaString() -> String {
        var metaString = self.getNumberOfProjectsString()
        metaString = metaString + " • "
        
        metaString = metaString + self.getTotalHoursString()
        metaString = metaString + " • "
        
        metaString = metaString + "since " + String(self.getCreationYear())
        
        return metaString
    }
    
    func getNumberOfProjectsString() -> String {
        return FormattingHelper.formatSomeNumberWithUnit(self.getNumberOfProjects(), unitSingular: "project", unitPlural: "projects")
    }
    
    func getTotalHoursString() -> String {
        return FormattingHelper.formatHoursAsString(self.getTotalHours())
    }
    
    func toJSON() -> Dictionary<String, AnyObject> {
        return [
            "uuid": self.uuid!,
            "name": self.name!,
            "street": self.street!,
            "postcode": self.postcode!,
            "city": self.city!,
            "note": self.note!,
            "commit": self.commit!,
            "created": FormattingHelper.getISOStringFromDate(self.created!),
            "changed": FormattingHelper.getISOStringFromDate(self.changed!)
        ]
    }

}
