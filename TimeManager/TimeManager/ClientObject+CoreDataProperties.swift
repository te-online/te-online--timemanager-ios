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
        let createdComponents: NSDateComponents = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: self.created!)
        return createdComponents.year
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
        let numberOfProjects = self.getNumberOfProjects()
        
        var numberOfProjectsString = String(numberOfProjects)
        
        if numberOfProjects != 1 {
            numberOfProjectsString = numberOfProjectsString + " projects"
        } else {
            numberOfProjectsString = numberOfProjectsString + " project"
        }
        
        return numberOfProjectsString
    }
    
    func getTotalHoursString() -> String {
        let totalHours = self.getTotalHours()
        
        var totalHoursString = ""
        
        if totalHours%1 == 0 {
            totalHoursString = totalHoursString + String(Int(totalHours))
        } else {
            totalHoursString = totalHoursString + String.localizedStringWithFormat("%.2f %@", totalHours, "")
        }
        
        if totalHours != 1 {
            totalHoursString = totalHoursString + " hrs."
        } else {
            totalHoursString = totalHoursString + " hr."
        }
        
        return totalHoursString
    }

}
