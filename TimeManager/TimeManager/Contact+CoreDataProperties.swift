//
//  Contact+CoreDataProperties.swift
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

extension Contact {

    @NSManaged var client_id: NSNumber?
    @NSManaged var commit: String?
    @NSManaged var id: NSNumber?
    @NSManaged var name: String?
    @NSManaged var client: ClientObject?

}
