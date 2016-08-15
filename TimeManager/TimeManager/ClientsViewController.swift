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
    
    var backgroundController: UIViewController!
    
    var clients = [Client]()
    
    struct Client {
        var clientName: String!
        var clientMeta: String!
    }
    
    var Colors = SharedColorPalette.sharedInstance
    
    var dataController: AppDelegate!
    
    var fetchedResultsController: NSFetchedResultsController!
    
    override func viewDidLoad() {
        dataController = UIApplication.sharedApplication().delegate as! AppDelegate
        
        self.collectionView!.backgroundColor = UIColor.clearColor()
        self.view!.backgroundColor = UIColor.whiteColor()
        
        // Load all the nice child views we're going to use.
        self.backgroundController = storyboard?.instantiateViewControllerWithIdentifier("ClientsInfoBackground")
        
        // Show the first view.
        self.displayContentController(backgroundController!)
        
        self.collectionView!.frame = CGRect(x: 0, y: 100, width: self.collectionView!.frame.width, height: self.collectionView!.frame.height - 100)
        
        clients = [Client(clientName: "CHOAM", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Acme Corp.", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Sirius Cybernetics Corp.", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Rich Industries", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Evil Corp.", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Soylent Corp.", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Very Big Corp. of America", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Frobozz Magic Co.", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Warbucks Industries", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Tyrell Corp.", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Wayne Enterprises", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Virtucon", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Globex", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Umbrella Corp.", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Wonka Industries", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Stark Industries", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Clampett Oil", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Oceanic Airlines", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Yoyodyne Propulsion Sys.", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Cyberdyne Systems Corp.", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "d’Anconia Copper", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Gringotts", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Oscorp", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Nakatomi Trading", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Spacely Space Sprockets", clientMeta: "2 projects • 224 hrs. • since 2012")]
        
        self.initializeFetchedResultsController()
        
//        do {
//            try fetchedResultsController.performFetch()
//            NSLog("Num " + String(fetchedResultsController.sections!.count))
//            self.collectionView?.reloadData()
//        } catch {
//            fatalError("Failure to perform fetch: \(error)")
//        }
        
//        let dummyClient: ClientEditController.Client = ClientEditController.Client(name: "My dummy client", street: "Some street", postcode: "", city: "", note: "")
//        self.saveNewClient(dummyClient)
        
        super.viewDidLoad()
    }
    
//    override func viewWillAppear(animated: Bool) {
//        
//        self.dataController = DataController()
//        self.initializeFetchedResultsController()
//        
//        super.viewWillAppear(animated)
//    }
    
    override func viewDidAppear(animated: Bool) {
//        self.dataController = DataController()
//        self.initializeFetchedResultsController()
        
//        do {
//            try fetchedResultsController.performFetch()
//            NSLog("Num " + String(fetchedResultsController.sections!.count))
//            self.collectionView?.reloadData()
//        } catch {
//            fatalError("Failure to perform fetch: \(error)")
//        }
        
        super.viewDidAppear(animated)
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
        do {
            try fetchedResultsController.performFetch()
            NSLog("Num " + String(fetchedResultsController.sections!.count))
            self.collectionView?.reloadData()
        } catch {
            fatalError("Failure to perform fetch: \(error)")
        }
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
//            do {
//                try fetchedResultsController.performFetch()
//                NSLog("Num " + String(fetchedResultsController.sections!.count))
//                self.collectionView?.reloadData()
//            } catch {
//                fatalError("Failure to perform fetch: \(error)")
//            }
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func configureCell(cell: UICollectionViewCell, indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.whiteColor()
        
//        if(empty == true) {
//            let ClientNameLabel = cell.viewWithTag(1) as! UILabel
//            ClientNameLabel.text = "It looks as if there were no clients yet."
//            
//            let ClientMetaLabel = cell.viewWithTag(2) as! UILabel
//            ClientMetaLabel.text = "Hit ”New“ to create your first one."
//        } else {
            let Client = fetchedResultsController.objectAtIndexPath(indexPath) as! ClientObject
            
            let ClientNameLabel = cell.viewWithTag(1) as! UILabel
            ClientNameLabel.text = Client.name
            
            let ClientMetaLabel = cell.viewWithTag(2) as! UILabel
            ClientMetaLabel.text = Client.street
//        }
        
        cell.backgroundColor = UIColor.whiteColor()
        
        cell.contentView.frame = cell.bounds
        cell.contentView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        
//        if indexPath.section == 0 {
//            cell = collectionView.dequeueReusableCellWithReuseIdentifier("empty", forIndexPath: indexPath) as UICollectionViewCell!
//            cell.backgroundColor = UIColor.clearColor()
//            cell.userInteractionEnabled = false
//        } else {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("ClientCell", forIndexPath: indexPath) as UICollectionViewCell!
            self.configureCell(cell, indexPath: indexPath)
//        }
        
        return cell
    }
    
    func displayContentController(content: UIViewController!) {
        // Add the new view controller.
        self.addChildViewController(content!)
        // Make sure the view fits perfectly into our layout.
        content!.view.frame = self.visibleFrameForEmbeddedControllers()
        // Add the new view.
        self.view!.insertSubview(content!.view, belowSubview: self.collectionView!)
        //        self.view!.addSubview(content!.view)
        // Tell the child that it now lives at their parents.
        content!.didMoveToParentViewController(self)
        content!.view.userInteractionEnabled = true
        
        content!.view.viewWithTag(1)!.backgroundColor = Colors.ProjectsCellBlue
    }
    
    func visibleFrameForEmbeddedControllers() -> CGRect {
        // Let's give them a rect, where the nav bar is still visible (Nav Bar is 86px in width and full height).
        let showRect = CGRect(x:0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 0.6)
        return showRect
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
        
//        NSLog("Kind: " + String(kind))
        
        if(kind == UICollectionElementKindSectionHeader) {
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "ClientsHeadCell", forIndexPath: indexPath)
            
//            if(indexPath.section == 0) {
//                headerView.backgroundColor = UIColor.clearColor()
//                headerView.alpha = 0
//                headerView.userInteractionEnabled = false
//            } else {
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
//            }
            
            reusableView = headerView
        }
        
        return reusableView
    }
    
    override func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        NSLog("Selected Clients Override" + String(collectionView))
        let cell: UICollectionViewCell! = collectionView.cellForItemAtIndexPath(indexPath)
        if cell != nil {
            cell.contentView.backgroundColor = Colors.VeryLightGrey
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell: UICollectionViewCell! = collectionView.cellForItemAtIndexPath(indexPath)
        if cell != nil {
            cell.contentView.backgroundColor = UIColor.whiteColor()
        }
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
        
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        let moc = appDelegate.managedObjectContext
        let moc = self.dataController.managedObjectContext
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            NSLog("Initialized")
//            self.collectionView?.reloadData()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
//        self.collectionView?.performBatchUpdates(<#T##updates: (() -> Void)?##(() -> Void)?##() -> Void#>, completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
        NSLog("Will change content")
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
        
        NSLog("Did change section")
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
        
        NSLog("Did change object")
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
//        tableView.endUpdates()
        self.collectionView?.reloadData()
        NSLog("Did change content")
    }
    
}
