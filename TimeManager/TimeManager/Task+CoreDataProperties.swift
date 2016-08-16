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

extension Task {

    @NSManaged var changed: NSDate?
    @NSManaged var commit: String?
    @NSManaged var created: NSDate?
    @NSManaged var uuid: String?
    @NSManaged var name: String?
    @NSManaged var project_uuid: String?
    @NSManaged var project: ProjectObject?
    @NSManaged var times: NSSet?

}
