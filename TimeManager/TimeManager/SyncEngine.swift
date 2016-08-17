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
                Objects.append(entries)
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
                Objects.append(entries)
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
                Objects.append(entries)
                let deleted = self.objectsToJSON(entries, entity: entity)
                Data[descriptorsMapping[index]]!["deleted"] = deleted
            } catch {
                fatalError("Failed to execute fetch request for todays hours: \(error)")
            }
        }
        
        NSLog("Data " + String(Data))

        RestApiManager.sharedInstance.sendUpdateRequest( ["data": Data, "lastCommit": "abcdefg"], onCompletion: { (json: JSON) in
            NSLog("results " + String(json.array))
        // With result do
        // For each category do
        // Insert new objects
        // Update changed objects
        // Delete deleted objects
        // Apply commit number to all collected uuid objects
//            if let results = json["results"].array {
//                for entry in results {
//                    self.items.append(UserObject(json: entry))
//                }
//                dispatch_async(dispatch_get_main_queue(),{
//                    self.tableView.reloadData()
//                })
//            }
        })
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