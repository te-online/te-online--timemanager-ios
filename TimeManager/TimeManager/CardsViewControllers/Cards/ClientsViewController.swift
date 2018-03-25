//
//  TestViewController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 11.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit
import CoreData

class ClientsViewController: CardOfViewDeckController, NSFetchedResultsControllerDelegate, ClientCreateDelegate {
    
    var Colors = SharedColorPalette.sharedInstance
    
    var dataController: AppDelegate!
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    var currentSelection: IndexPath!
    
    override func viewDidLoad() {
        // Let's get our data controller from the App Delegate.
        dataController = UIApplication.shared.delegate as! AppDelegate
        
        self.collectionView!.backgroundColor = UIColor.clear
        self.view!.backgroundColor = UIColor.white
        
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
    
    @IBAction func saveClient(_ unwindSegue: UIStoryboardSegue) {
        (unwindSegue.source as! ClientEditController).createDelegate = self
    }
    
    @IBAction func cancelClient(_ unwindSegue: UIStoryboardSegue) {
        // Do nothing. Relax.
    }
    
    /**
     *
     *   STORAGE ACTIONS
     *
     **/
    
    func saveNewClient(_ client: ClientEditController.Client) {
        let entity = NSEntityDescription.entity(forEntityName: "Client", in: dataController.managedObjectContext)
        let item = NSManagedObject(entity: entity!, insertInto: dataController.managedObjectContext)
        
        let now = Date()
        
        item.setValue(UUID().uuidString, forKey: "uuid")
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
    
    func configureCell(_ cell: UICollectionViewCell, indexPath: IndexPath) {
        cell.backgroundColor = UIColor.white
        
        let Client = fetchedResultsController.object(at: indexPath) as! ClientObject
        
        let ClientNameLabel = cell.viewWithTag(1) as! UILabel
        ClientNameLabel.text = Client.name
        
        let ClientMetaLabel = cell.viewWithTag(2) as! UILabel
        ClientMetaLabel.text = Client.getMetaString()
        
        if currentSelection != nil && (indexPath == currentSelection) {
            cell.contentView.backgroundColor = Colors.VeryLightGrey
        } else {
            cell.contentView.backgroundColor = UIColor.white
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClientCell", for: indexPath) as UICollectionViewCell!
        self.configureCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView: UICollectionReusableView!
        reusableView = nil
        
        if(kind == UICollectionElementKindSectionHeader) {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ClientsHeadCell", for: indexPath)
            
            headerView.backgroundColor = UIColor.white
            
            let NewButton = headerView.viewWithTag(3) as! UIButton
            NewButton.layer.borderColor = UIColor(colorLiteralRed: 0.537254902, green: 0.8, blue: 1, alpha: 1).cgColor
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
    
    override func collectionView(_ myView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return super.getCellSize()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currentSelection = indexPath
        self.collectionView!.reloadData()
        
        super.collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.currentSelection = nil
        self.collectionView!.reloadData()
    }
    
    /**
     *
     *   HELPER
     *
     **/
    
    func getClientIdForIndexPath(_ indexPath: IndexPath) -> String {
        return (fetchedResultsController.object(at: indexPath) as! ClientObject).uuid!
    }
    
    func getCurrentClient() -> ClientObject {
        if self.currentSelection != nil {
            return (fetchedResultsController.object(at: self.currentSelection) as! ClientObject)
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
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Client")
        let nameSort = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
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
    
    /**
     *
     *   This doesn't work, because we manipulate the index for the invisible cell at the top.
     *   When we do this and there is a change in the data of the fetched results controller, we'll get an error.
     *   Maybe with some kind of manipulation it could be solved.
     *
     **/
    
//    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
//        switch type {
//        case .Insert:
//            self.collectionView!.insertSections(NSIndexSet(index: sectionIndex))
//        case .Delete:
//            self.collectionView!.deleteSections(NSIndexSet(index: sectionIndex))
//        case .Move:
//            break
//        case .Update:
//            break
//        }
//    }
//    
//    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
//        switch type {
//        case .Insert:
//            self.collectionView!.insertItemsAtIndexPaths([newIndexPath!])
//        case .Delete:
//            self.collectionView!.deleteItemsAtIndexPaths([indexPath!])
//        case .Update:
//            configureCell(self.collectionView!.cellForItemAtIndexPath(indexPath!)!, indexPath: indexPath!)
//        case .Move:
//            self.collectionView!.deleteItemsAtIndexPaths([indexPath!])
//            self.collectionView!.insertItemsAtIndexPaths([indexPath!])
//        }
//    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.collectionView?.reloadData()
    }
    
}
