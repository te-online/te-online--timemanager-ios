//
//  SyncEngine.swift
//  TimeManager
//
//  Created by Thomas Ebert on 17.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

class SyncEngine {
    
    // We need this ”dictionary“, because the server likes plural entities and Core Data likes singular entities.
    var entityMapping = ["Client", "Project", "Task", "Time"]
    var descriptorsMapping = ["clients", "projects", "tasks", "times"]
    
    let defaults = UserDefaults.standard
    var appDelegate: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
    var syncManagedObjectContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).backgroundManagedObjectContext
    
    var Data: [String: [String: [AnyObject]]]!
    
    struct DataCollection {
        var created: [AnyObject]
        var updated: [AnyObject]
        var deleted: [AnyObject]
    }
    
    var Objects: [[AnyObject]] = []
    var Deletables: [[AnyObject]] = []
    
    func doSyncJob() {
        // Prepare data
        Data = [
            "clients": [
                "created": [],
                "updated": [],
                "deleted": []
            ],
            "projects": [
                "created": [],
                "updated": [],
                "deleted": []
            ],
            "tasks": [
                "created": [],
                "updated": [],
                "deleted": []
            ],
            "times": [
                "created": [],
                "updated": [],
                "deleted": []
            ]
        ]
        
        // For each category do (collect all items in a list)
        for (index, entity) in entityMapping.enumerated() {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            
            let changedSort = NSSortDescriptor(key: "changed", ascending: true)
            request.sortDescriptors = [changedSort]
            
            // New status: Load all objects that have nil as commit into a list.
            let newElements = NSPredicate(format: "(commit = nil) AND (created = changed)")
            request.predicate = newElements
            
            do {
                let entries = try self.syncManagedObjectContext.fetch(request)
                self.Objects.append(entries as [AnyObject])
                let created = self.objectsToJSON(entries as [AnyObject], entity: entity)
                Data[descriptorsMapping[index]]!["created"] = created
            } catch {
                fatalError("Failed to execute fetch request for todays hours: \(error)")
            }
            
            // Changed status: Load all objects with different created and changed date and nil as commit into a list.
            let updatedElements = NSPredicate(format: "(commit = nil) AND (created != changed)")
            request.predicate = updatedElements
            
            do {
                let entries = try self.syncManagedObjectContext.fetch(request)
                self.Objects.append(entries as [AnyObject])
                let updated = self.objectsToJSON(entries as [AnyObject], entity: entity)
                Data[descriptorsMapping[index]]!["updated"] = updated
            } catch {
                fatalError("Failed to execute fetch request for todays hours: \(error)")
            }
            
            // Deleted status: Load all objects that have "deleted" as commit into a dictionary
            let deletedElements = NSPredicate(format: "commit = %@", "deleted")
            request.predicate = deletedElements
            
            do {
                let entries = try self.syncManagedObjectContext.fetch(request)
                self.Objects.append(entries as [AnyObject])
                self.Deletables.append(entries as [AnyObject])
                let deleted = self.objectsToJSON(entries as [AnyObject], entity: entity)
                Data[descriptorsMapping[index]]!["deleted"] = deleted
            } catch {
                fatalError("Failed to execute fetch request for todays hours: \(error)")
            }
        }
        
        NSLog("Synchronizing...")
        
        // The last commit numer is either stored in the defaults or ... empty.
        let lastCommit = self.defaults.string(forKey: "lastCommit") ?? ""

        RestApiManager.sharedInstance.sendUpdateRequest( ["data": Data as AnyObject, "lastCommit": lastCommit as AnyObject], onCompletion: { (json: JSON) in
            // If we get something back that looks like a new commit number, we apply it to all touched items.
            
            if let commit = json["commit"].string {
                self.syncManagedObjectContext.performAndWait {
                    NSLog("New commit: %@", commit)
                    // Save it to the defaults.
                    self.defaults.setValue(commit, forKey: "lastCommit")
                    
                    // All sent objects will now get the new commit number from the server, because they were saved.
                    for entries in self.Objects {
                        for entry in entries {
                            if (!(((entry as! NSManagedObject).value(forKey: "commit") as AnyObject).isEqual(String("deleted")))) {
                                entry.setValue(commit, forKey: "commit")
                                
                                self.syncManagedObjectContext.performAndWait {
                                    do {
                                        try self.syncManagedObjectContext.save()
                                    } catch {
                                        fatalError("Failed to save commit to synced entries: \(error)")
                                    }
                                }
                            }
                        }
                    }
                }
                
                self.syncManagedObjectContext.performAndWait {
                    // All objects flagged for deletion will now be permanently deleted.
                    for entries in self.Deletables {
                        for entry in entries {
                            self.syncManagedObjectContext.delete(entry as! NSManagedObject)
                        }
                    }
                }                
                
                self.syncManagedObjectContext.performAndWait {
                    do {
                        try self.syncManagedObjectContext.save()
                    } catch {
                        fatalError("Failed to save commit to synced entries: \(error)")
                    }
                }
                
            }
            
            // Wow, it's like christmas: We also get some data back from the server.
            if let data = json["data"].dictionary {
                // We want to check every entity for elements.
                for (index, entity) in self.entityMapping.enumerated() {
                    // Are there created ones? Create them.
                    if let created = data[self.descriptorsMapping[index]]!["created"].array {
                        for object in created {
                            self.createObject(object, entityName: entity)
                        }
                    }
                    // Are there updated ones? Update them.
                    if let updated = data[self.descriptorsMapping[index]]!["updated"].array {
                        for object in updated {
                            self.updateObject(object, entityName: entity)
                        }
                    }
                    // Are there deleted ones? Delete them.
                    if let deleted = data[self.descriptorsMapping[index]]!["deleted"].array {
                        for object in deleted {
                            self.deleteObject(object, entityName: entity)
                        }
                    }
                }
            }
            
            // Just to be sure: Save everything.
            self.syncManagedObjectContext.performAndWait {
                do {
                    try self.syncManagedObjectContext.save()
                } catch {
                    fatalError("Failed to save objects in sync process: \(error)")
                }
            }
            
            self.appDelegate.saveContext()
        })
    }
    
    // This function creates an object from the remote server in Core Data.
    func createObject(_ object: JSON, entityName: String) {
        self.syncManagedObjectContext.performAndWait {
            let entity = NSEntityDescription.entity(forEntityName: entityName, in: syncManagedObjectContext)
            let item = NSManagedObject(entity: entity!, insertInto: syncManagedObjectContext)
        
            // 4 fields actually need to be converted from string to date, before they can be inserted into Core Data.
            for (key, value) in object.dictionary! {
                if(key == "created" || key == "changed" || key == "start" || key == "end") {
                    item.setValue(FormattingHelper.getDateFromISOString(value.string!), forKey: key)
                } else {
                    item.setValue(value.string, forKey: key)
                }
            }
            
            if(entityName == "Project") {
                // We need to set a client as the parent. Let's find him a parent.
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Client")
                
                let parentElement = NSPredicate(format: "uuid = %@", object["client_uuid"].string!)
                request.predicate = parentElement
                
                let moc = self.syncManagedObjectContext
                
                do {
                    let objects = try moc.fetch(request)
                    if(objects.count > 0) {
                        let Client = objects[0]
                        
                        (item as! ProjectObject).client = (Client as! ClientObject)
                    }
                } catch {
                    fatalError("Failed to execute fetch request for parent client in sync process: \(error)")
                }
            } else if(entityName == "Task") {
                // We need to set a project as the parent. Let's find him a parent.
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Project")
                
                let parentElement = NSPredicate(format: "uuid = %@", object["project_uuid"].string!)
                request.predicate = parentElement
                
                let moc = self.syncManagedObjectContext
                
                do {
                    let objects = try moc.fetch(request)
                    if(objects.count > 0) {
                        let Project = objects[0]
                        
                        (item as! TaskObject).project = (Project as! ProjectObject)
                    }
                } catch {
                    fatalError("Failed to execute fetch request for parent client in sync process: \(error)")
                }
            } else if(entityName == "Time") {
                // We need to set a task as the parent. Let's find him a parent.
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
                
                let parentElement = NSPredicate(format: "uuid = %@", object["task_uuid"].string!)
                request.predicate = parentElement
                
                let moc = self.syncManagedObjectContext
                
                do {
                    let objects = try moc.fetch(request)
                    if(objects.count > 0) {
                        let Task = objects[0]
                        
                        (item as! TimeObject).task = (Task as! TaskObject)
                    }
                } catch {
                    fatalError("Failed to execute fetch request for parent client in sync process: \(error)")
                }
            }
        }
        
        // Save everything.
        self.syncManagedObjectContext.performAndWait {
            do {
                try self.syncManagedObjectContext.save()
            } catch {
                fatalError("Failed to save objects in sync process: \(error)")
            }
        }
        
        self.appDelegate.saveContext()
    }
    
    // This function tries to update objects that come from the server. If there is no local copy, they will be created.
    func updateObject(_ object: JSON, entityName: String) {
        self.syncManagedObjectContext.performAndWait {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            
            let thisElement = NSPredicate(format: "uuid = %@", object["uuid"].string!)
            request.predicate = thisElement
            
            do {
                let objects = try self.syncManagedObjectContext.fetch(request)
                if(objects.count > 0) {
                    let item = objects[0]
                    
                    // If there is an object like the updated one, just replace all the attributes with the new ones.
                    for (key, value) in object.dictionary! {
                        // 4 fields actually need to be converted from string to date, before they can be inserted into Core Data.
                        if(key == "created" || key == "changed" || key == "start" || key == "end") {
                            (item as AnyObject).setValue(FormattingHelper.getDateFromISOString(value.string!), forKey: key)
                        } else {
                            (item as AnyObject).setValue(value.string, forKey: key)
                        }
                    }
                } else {
                    // Okay, can't find it. Let's create one.
                    self.createObject(object, entityName: entityName)
                }
            } catch {
                fatalError("Failed to execute fetch request alter item in sync process: \(error)")
            }
        }
        
        self.appDelegate.saveContext()
    }
    
    // This function deleted objects that were marked as deleted by the server.
    func deleteObject(_ object: JSON, entityName: String) {
        self.syncManagedObjectContext.performAndWait {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            
            let thisElement = NSPredicate(format: "uuid = %@", object["uuid"].string!)
            request.predicate = thisElement
            
            do {
                let objects = try self.syncManagedObjectContext.fetch(request)
                // Found it? Just delete it.
                if(objects.count > 0) {
                    let item = objects[0]
                    
                    self.syncManagedObjectContext.delete(item as! NSManagedObject)
                }
            } catch {
                fatalError("Failed to execute fetch request for delete item in sync process: \(error)")
            }
        }
        
        self.appDelegate.saveContext()
    }
    
    // Let's convert all the fancy ManagedObjects to plain (JSON-ish) text.
    func objectsToJSON(_ entries: [AnyObject], entity: String) -> [NSDictionary] {
        var convertedEntries = [NSDictionary]()
        for entry in entries {
            if(entity == "Client") {
                convertedEntries.append((entry as! ClientObject).toJSON() as NSDictionary)
            }
            if(entity == "Project") {
                convertedEntries.append((entry as! ProjectObject).toJSON() as NSDictionary)
            }
            if(entity == "Task") {
                convertedEntries.append((entry as! TaskObject).toJSON() as NSDictionary)
            }
            if(entity == "Time") {
                convertedEntries.append((entry as! TimeObject).toJSON() as NSDictionary)
            }
        }
        
        return convertedEntries
    }
}
