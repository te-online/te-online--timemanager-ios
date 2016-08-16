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
        if projects != nil {
            return self.projects!.count
        }
        
        return 0
    }
    
    func getTotalHours() -> Double {
        var totalHours: Double = 0
        
        if projects != nil {
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
        let numberOfProjects = self.getNumberOfProjects()
        let totalHours = self.getTotalHours()
        let creationYear = self.getCreationYear()
        
        var metaString = String(numberOfProjects)
        if numberOfProjects != 1 {
            metaString = metaString + " projects • "
        } else {
            metaString = metaString + " project • "
        }
        
        if totalHours%2 == 0 {
            metaString = metaString + String(Int(totalHours))
        } else {
            metaString = metaString + String.localizedStringWithFormat("%.2f %@", totalHours, "")
        }
        
        if totalHours != 1 {
            metaString = metaString + " hrs. • "
        } else {
            metaString = metaString + " hr. • "
        }
        
        metaString = metaString + "since " + String(creationYear)
        
        return metaString
    }

}
