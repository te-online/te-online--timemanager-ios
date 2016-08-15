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

extension Time {

    @NSManaged var changed: NSDate?
    @NSManaged var commit: String?
    @NSManaged var created: NSDate?
    @NSManaged var end: NSDate?
    @NSManaged var id: NSNumber?
    @NSManaged var note: String?
    @NSManaged var start: NSDate?
    @NSManaged var task_id: NSNumber?
    @NSManaged var task: Task?

}