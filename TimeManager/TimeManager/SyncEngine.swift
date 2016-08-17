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
    
    var Data: [[AnyObject]] = []
    
    struct DataCollection {
        var created: [AnyObject]
        var updated: [AnyObject]
        var deleted: [AnyObject]
    }
    
    func doSyncJob() {
        // Prepare data
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
                var created = try moc.executeFetchRequest(request)
                for (index, obj) in created.enumerate() {
                    for (key, value) in (obj as! NSDictionary) {
                        if key as! String == "created" {
                            created[index][key] = FormattingHelper.getISOStringFromDate(value as! NSDate)
                        }
                    }
                    NSLog("obj " + String(obj))
//                    if obj["created"] != nil {
//                        obj["created"] = FormattingHelper.getISOStringFromDate(obj["created"] as NSDate)
//                    }
                }
                Data.append([created])
            } catch {
                fatalError("Failed to execute fetch request for todays hours: \(error)")
            }
            
            // Changed: Load all objects with different created and changed date and nil as commit into a dictionary
            let updatedElements = NSPredicate(format: "(commit = nil) AND (created != changed)")
            request.predicate = updatedElements
            
            do {
                
                let updated = try moc.executeFetchRequest(request)
                Data[index].append(updated)
            } catch {
                fatalError("Failed to execute fetch request for todays hours: \(error)")
            }
            
            // Deleted: Load all objects that have "deleted" as commit into a dictionary
            let deletedElements = NSPredicate(format: "commit = %@", "deleted")
            request.predicate = deletedElements
            
            do {
                
                let deleted = try moc.executeFetchRequest(request)
                Data[index].append(deleted)
            } catch {
                fatalError("Failed to execute fetch request for todays hours: \(error)")
            }
        }
        
        NSLog("Data " + String(Data))

        RestApiManager.sharedInstance.sendUpdateRequest( ["data": Data], onCompletion: { (json: JSON) in
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
}