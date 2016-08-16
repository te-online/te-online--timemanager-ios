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

}
