//
//  TestViewController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 11.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit
import CoreData

class ClientsViewController: CardOfViewDeckController, NSFetchedResultsControllerDelegate, ClientEditDelegate {
    
    var Colors = SharedColorPalette.sharedInstance
    
    var dataController: AppDelegate!
    
    var fetchedResultsController: NSFetchedResultsController!
    
    var currentSelection: NSIndexPath!
    
    override func viewDidLoad() {
        // Let's get our data controller from the App Delegate.
        dataController = UIApplication.sharedApplication().delegate as! AppDelegate
        
        self.collectionView!.backgroundColor = UIColor.clearColor()
        self.view!.backgroundColor = UIColor.whiteColor()
        
        self.initializeFetchedResultsController()
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     *
     *   UNWIND BUTTON ACTIONS
     *
    **/
    
    @IBAction func saveClient(unwindSegue: UIStoryboardSegue) {
        NSLog(String(unwindSegue.sourceViewController))
        (unwindSegue.sourceViewController as! ClientEditController).delegate = self
    }
    
    @IBAction func cancelClient(unwindSegue: UIStoryboardSegue) {
        
    }
    
    /**
     *
     *   STORAGE ACTIONS
     *
     **/
    
    func saveNewClient(client: ClientEditController.Client) {
        NSLog("Name" + String(client))
        let entity = NSEntityDescription.entityForName("Client", inManagedObjectContext: dataController.managedObjectContext)
        let item = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: dataController.managedObjectContext)
        
        let now = NSDate()
        
        item.setValue(NSUUID().UUIDString, forKey: "uuid")
        item.setValue(client.name, forKey: "name")
        item.setValue(client.street, forKey: "street")
        item.setValue(client.postcode, forKey: "postcode")
        item.setValue(client.city, forKey: "city")
        item.setValue(client.note, forKey: "note")
        item.setValue(now, forKey: "changed")
        item.setValue(now, forKey: "created")
        
        do {
            try dataController.managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    /**
     *
     *   COLLECTION VIEW
     *
     **/
    
    func configureCell(cell: UICollectionViewCell, indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.whiteColor()
        
        let Client = fetchedResultsController.objectAtIndexPath(indexPath) as! ClientObject
        
        let ClientNameLabel = cell.viewWithTag(1) as! UILabel
        ClientNameLabel.text = Client.name
        
        let ClientMetaLabel = cell.viewWithTag(2) as! UILabel
        ClientMetaLabel.text = Client.getMetaString()
        
        if currentSelection != nil && indexPath.isEqual(currentSelection) {
            cell.contentView.backgroundColor = Colors.VeryLightGrey
        } else {
            cell.contentView.backgroundColor = UIColor.whiteColor()
        }
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        
        cell = collectionView.dequeueReusableCellWithReuseIdentifier("ClientCell", forIndexPath: indexPath) as UICollectionViewCell!
        self.configureCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var reusableView: UICollectionReusableView!
        reusableView = nil
        
        if(kind == UICollectionElementKindSectionHeader) {
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "ClientsHeadCell", forIndexPath: indexPath)
            
            headerView.backgroundColor = UIColor.whiteColor()
            
            let NewButton = headerView.viewWithTag(3) as! UIButton
            NewButton.layer.borderColor = UIColor(colorLiteralRed: 0.537254902, green: 0.8, blue: 1, alpha: 1).CGColor
            NewButton.layer.cornerRadius = 2
            NewButton.layer.borderWidth = 1
            NewButton.layer.masksToBounds = true
            
            // Update number of items in header view.
            let itemCount = (fetchedResultsController.sections!.count > 0) ? fetchedResultsController.sections![0].numberOfObjects : 0
            let itemCountLabel = headerView.viewWithTag(2) as! UILabel
            itemCountLabel.text = "#" + String(itemCount)
            
            reusableView = headerView
        }
        
        return reusableView
    }
    
    override func collectionView(myView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return super.getCellSize()
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.currentSelection = indexPath
        self.collectionView!.reloadData()
        
        super.collectionView(collectionView, didSelectItemAtIndexPath: indexPath)
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        self.currentSelection = nil
        self.collectionView!.reloadData()
    }
    
    /**
     *
     *   HELPER
     *
     **/
    
    func getClientIdForIndexPath(indexPath: NSIndexPath) -> String {
        return (fetchedResultsController.objectAtIndexPath(indexPath) as! ClientObject).uuid!
    }
    
    func getCurrentClient() -> ClientObject {
        if self.currentSelection != nil {
            return (fetchedResultsController.objectAtIndexPath(self.currentSelection) as! ClientObject)
        } else {
            return ClientObject()
        }
    }
    
    /**
     *
     *   FETCHED RESULTS CONTROLLER
     *
     **/
    
    func initializeFetchedResultsController() {
        let request = NSFetchRequest(entityName: "Client")
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [nameSort]
        
        let notDeleted = NSPredicate(format: "((commit == nil) OR (commit != %@))", "deleted")
        request.predicate = notDeleted
        
        let moc = self.dataController.managedObjectContext
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.collectionView!.insertSections(NSIndexSet(index: sectionIndex))
        case .Delete:
            self.collectionView!.deleteSections(NSIndexSet(index: sectionIndex))
        case .Move:
            break
        case .Update:
            break
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            self.collectionView!.insertItemsAtIndexPaths([newIndexPath!])
        case .Delete:
            self.collectionView!.deleteItemsAtIndexPaths([indexPath!])
        case .Update:
            configureCell(self.collectionView!.cellForItemAtIndexPath(indexPath!)!, indexPath: indexPath!)
        case .Move:
            self.collectionView!.deleteItemsAtIndexPaths([indexPath!])
            self.collectionView!.insertItemsAtIndexPaths([indexPath!])
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.collectionView?.reloadData()
    }
    
}
