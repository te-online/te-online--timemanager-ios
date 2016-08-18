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
    
    var entityMapping = ["Client", "Project", "Task", "Time"]
    var descriptorsMapping = ["clients", "projects", "tasks", "times"]
    
    var dataController: AppDelegate! = UIApplication.sharedApplication().delegate as! AppDelegate
    
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
            // For each category do (collect all uuids in a list)
        for (index, entity) in entityMapping.enumerate() {
            let request = NSFetchRequest(entityName: entity)
            
//            request.resultType = .DictionaryResultType
            
            let changedSort = NSSortDescriptor(key: "changed", ascending: true)
            request.sortDescriptors = [changedSort]
            
            // New: Load all objects that have nil as commit into a dictionary
            let newElements = NSPredicate(format: "(commit = nil) AND (created = changed)")
            request.predicate = newElements
            
            let moc = self.dataController.managedObjectContext
            
            do {
                let entries = try moc.executeFetchRequest(request)
                self.Objects.append(entries)
                let created = self.objectsToJSON(entries, entity: entity)
                Data[descriptorsMapping[index]]!["created"] = created
            } catch {
                fatalError("Failed to execute fetch request for todays hours: \(error)")
            }
            
            // Changed: Load all objects with different created and changed date and nil as commit into a dictionary
            let updatedElements = NSPredicate(format: "(commit = nil) AND (created != changed)")
            request.predicate = updatedElements
            
            do {
                let entries = try moc.executeFetchRequest(request)
                self.Objects.append(entries)
                let updated = self.objectsToJSON(entries, entity: entity)
                Data[descriptorsMapping[index]]!["updated"] = updated
            } catch {
                fatalError("Failed to execute fetch request for todays hours: \(error)")
            }
            
            // Deleted: Load all objects that have "deleted" as commit into a dictionary
            let deletedElements = NSPredicate(format: "commit = %@", "deleted")
            request.predicate = deletedElements
            
            do {
                let entries = try moc.executeFetchRequest(request)
                self.Objects.append(entries)
                self.Deletables.append(entries)
                let deleted = self.objectsToJSON(entries, entity: entity)
                Data[descriptorsMapping[index]]!["deleted"] = deleted
            } catch {
                fatalError("Failed to execute fetch request for todays hours: \(error)")
            }
        }
        
//        NSLog("Data " + String(Data))
        NSLog("Synchronizing...")
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let lastCommit = defaults.stringForKey("lastCommit") ?? ""

        RestApiManager.sharedInstance.sendUpdateRequest( ["data": Data, "lastCommit": lastCommit], onCompletion: { (json: JSON) in
//            NSLog("results " + String(json.array))
            if let commit = json[0]["commit"].string {
                NSLog("commit " + commit)
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setValue(commit, forKey: "lastCommit")
                
                for entries in self.Objects {
                    for entry in entries {
                        if (((entry as! NSManagedObject).valueForKey("commit")?.isEqual(String("deleted"))) == nil) {
//                            self.dataController.managedObjectContext.deleteObject(entry as! NSManagedObject)
//                        } else {
                            entry.setValue(commit, forKey: "commit")
                        }
                    }
                }
                
//                NSLog("Deletables " + String(self.Deletables))
                
                for entries in self.Deletables {
                    for entry in entries {
                        self.dataController.managedObjectContext.deleteObject(entry as! NSManagedObject)
                    }
                }
                
                let moc = self.dataController.managedObjectContext
                do {
                    try moc.save()
                } catch {
                    fatalError("Failed to save commit to synced entries: \(error)")
                }
                
            }
            if let data = json[0]["data"].dictionary {
                for (index, entity) in self.entityMapping.enumerate() {
                    if let created = data[self.descriptorsMapping[index]]!["created"].array {
                        for object in created {
//                            NSLog("new created ones" + String(object.dictionary))
                            self.createObject(object, entityName: entity)
                        }
                    }
                    if let updated = data[self.descriptorsMapping[index]]!["updated"].array {
                        for object in updated {
                            self.updateObject(object, entityName: entity)
                        }
                    }
                    if let deleted = data[self.descriptorsMapping[index]]!["deleted"].array {
                        for object in deleted {
                            self.deleteObject(object, entityName: entity)
                        }
                    }
                }
            }
            do {
                try self.dataController.managedObjectContext.save()
            } catch {
                fatalError("Failed to save objects in sync process: \(error)")
            }
        })
    }
    
    func createObject(object: JSON, entityName: String) {
        let entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: dataController.managedObjectContext)
        let item = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: dataController.managedObjectContext)
        
        for (key, value) in object.dictionary! {
            if(key == "created" || key == "changed" || key == "start" || key == "end") {
                item.setValue(FormattingHelper.getDateFromISOString(value.string!), forKey: key)
            } else {
                item.setValue(value.string, forKey: key)
            }
        }
        
        if(entityName == "Project") {
            // We need to set a client as the parent
            let request = NSFetchRequest(entityName: "Client")
            
            let parentElement = NSPredicate(format: "uuid = %@", object["client_uuid"].string!)
            request.predicate = parentElement
            
            let moc = self.dataController.managedObjectContext
            
            do {
                let objects = try moc.executeFetchRequest(request)
                if(objects.count > 0) {
                    let Client = objects[0]
                    
                    (item as! ProjectObject).client = (Client as! ClientObject)
                }
            } catch {
                fatalError("Failed to execute fetch request for parent client in sync process: \(error)")
            }
        } else if(entityName == "Task") {
            // We need to set a client as the parent
            let request = NSFetchRequest(entityName: "Project")
            
            let parentElement = NSPredicate(format: "uuid = %@", object["project_uuid"].string!)
            request.predicate = parentElement
            
            let moc = self.dataController.managedObjectContext
            
            do {
                let objects = try moc.executeFetchRequest(request)
                if(objects.count > 0) {
                    let Project = objects[0]
                    
                    (item as! TaskObject).project = (Project as! ProjectObject)
                }
            } catch {
                fatalError("Failed to execute fetch request for parent client in sync process: \(error)")
            }
        } else if(entityName == "Time") {
            // We need to set a client as the parent
            let request = NSFetchRequest(entityName: "Task")
            
            let parentElement = NSPredicate(format: "uuid = %@", object["task_uuid"].string!)
            request.predicate = parentElement
            
            let moc = self.dataController.managedObjectContext
            
            do {
                let objects = try moc.executeFetchRequest(request)
                if(objects.count > 0) {
                    let Task = objects[0]
                    
                    (item as! TimeObject).task = (Task as! TaskObject)
                }
            } catch {
                fatalError("Failed to execute fetch request for parent client in sync process: \(error)")
            }
        }
    }
    
    func updateObject(object: JSON, entityName: String) {
        let request = NSFetchRequest(entityName: entityName)
        
        let thisElement = NSPredicate(format: "uuid = %@", object["uuid"].string!)
        request.predicate = thisElement
        
        let moc = self.dataController.managedObjectContext
        
        do {
            let objects = try moc.executeFetchRequest(request)
            if(objects.count > 0) {
                let item = objects[0]
                
                for (key, value) in object.dictionary! {
                    if(key == "created" || key == "changed" || key == "start" || key == "end") {
                        item.setValue(FormattingHelper.getDateFromISOString(value.string!), forKey: key)
                    } else {
                        item.setValue(value.string, forKey: key)
                    }
                }
            }
        } catch {
            fatalError("Failed to execute fetch request alter item in sync process: \(error)")
        }

    }
    
    func deleteObject(object: JSON, entityName: String) {
        let request = NSFetchRequest(entityName: entityName)
        
        let thisElement = NSPredicate(format: "uuid = %@", object["uuid"].string!)
        request.predicate = thisElement
        
        let moc = self.dataController.managedObjectContext
        
        do {
            let objects = try moc.executeFetchRequest(request)
            if(objects.count > 0) {
                let item = objects[0]
            
                moc.deleteObject(item as! NSManagedObject)
            }
        } catch {
            fatalError("Failed to execute fetch request for delete item in sync process: \(error)")
        }
        
    }
    
    func objectsToJSON(entries: [AnyObject], entity: String) -> [NSDictionary] {
        var convertedEntries = [NSDictionary]()
        for entry in entries {
            if(entity == "Client") {
                convertedEntries.append((entry as! ClientObject).toJSON())
            }
            if(entity == "Project") {
                convertedEntries.append((entry as! ProjectObject).toJSON())
            }
            if(entity == "Task") {
                convertedEntries.append((entry as! TaskObject).toJSON())
            }
            if(entity == "Time") {
                convertedEntries.append((entry as! TimeObject).toJSON())
            }
        }
        
        return convertedEntries
    }
}