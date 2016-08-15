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
    var currentSelectionId: Int = -1
    
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
    
    @IBAction func saveClient(unwindSegue: UIStoryboardSegue) {
        NSLog(String(unwindSegue.sourceViewController))
        (unwindSegue.sourceViewController as! ClientEditController).delegate = self
    }
    
    @IBAction func cancelClient(unwindSegue: UIStoryboardSegue) {
        
    }
    
    func saveNewClient(client: ClientEditController.Client) {
        NSLog("Name" + String(client))
        let entity = NSEntityDescription.entityForName("Client", inManagedObjectContext: dataController.managedObjectContext)
        let item = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: dataController.managedObjectContext)
        
        item.setValue(1, forKey: "id")
        item.setValue(client.name, forKey: "name")
        item.setValue(client.street, forKey: "street")
        item.setValue(client.postcode, forKey: "postcode")
        item.setValue(client.city, forKey: "city")
        item.setValue(client.note, forKey: "note")
        item.setValue(NSDate(), forKey: "changed")
        item.setValue(NSDate(), forKey: "created")
        
        do {
            try dataController.managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func configureCell(cell: UICollectionViewCell, indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.whiteColor()
        
        let Client = fetchedResultsController.objectAtIndexPath(indexPath) as! ClientObject
        
        let ClientNameLabel = cell.viewWithTag(1) as! UILabel
        ClientNameLabel.text = Client.name
        
        let ClientMetaLabel = cell.viewWithTag(2) as! UILabel
        ClientMetaLabel.text = Client.street
        
//        NSLog("configuring...")
        if currentSelection != nil && indexPath.isEqual(currentSelection) {
            NSLog("selected one")
            cell.contentView.backgroundColor = Colors.VeryLightGrey
        } else {
            cell.contentView.backgroundColor = UIColor.whiteColor()
        }
        
        cell.contentView.frame = cell.bounds
        cell.contentView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
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
        //        let actualSection = section - 1
        //        if actualSection >= 0 {
        //            return fetchedResultsController.sections![actualSection].numberOfObjects
        //        } else {
        //            return 1
        //        }
        
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
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        currentSelection = indexPath
        currentSelectionId = self.getClientIdForIndexPath(indexPath)
        
        self.collectionView!.reloadData()
        
        super.collectionView(collectionView, didSelectItemAtIndexPath: indexPath)
    }
    
    //    override func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
    ////        NSLog("Selected Clients Override" + String(collectionView))
    //        let cell: UICollectionViewCell! = collectionView.cellForItemAtIndexPath(indexPath)
    //        if cell != nil {
    //            cell.contentView.backgroundColor = Colors.VeryLightGrey
    //        }
    //    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        //        let cell: UICollectionViewCell! = collectionView.cellForItemAtIndexPath(indexPath)
        //        if cell != nil {
        //            cell.contentView.backgroundColor = UIColor.whiteColor()
        //        }
        currentSelection = nil
    }
    
    func getClientIdForIndexPath(indexPath: NSIndexPath) -> Int {
        return ((fetchedResultsController.objectAtIndexPath(indexPath) as! ClientObject).id as! Int)
    }
    
    
    //    override func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
    //        let cell: UICollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath)!
    //        let color = UIColor.whiteColor()
    //
    //        cell.contentView.backgroundColor = color
    //    }
    
    func initializeFetchedResultsController() {
        let request = NSFetchRequest(entityName: "Client")
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [nameSort]
        
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
