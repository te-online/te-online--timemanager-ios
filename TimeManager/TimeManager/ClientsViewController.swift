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
    
    var dataController: DataController!
    
    var fetchedResultsController: NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.backgroundColor = UIColor.clearColor()
        self.view!.backgroundColor = UIColor.whiteColor()
        
        clients = [Client(clientName: "CHOAM", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Acme Corp.", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Sirius Cybernetics Corp.", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Rich Industries", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Evil Corp.", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Soylent Corp.", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Very Big Corp. of America", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Frobozz Magic Co.", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Warbucks Industries", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Tyrell Corp.", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Wayne Enterprises", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Virtucon", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Globex", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Umbrella Corp.", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Wonka Industries", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Stark Industries", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Clampett Oil", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Oceanic Airlines", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Yoyodyne Propulsion Sys.", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Cyberdyne Systems Corp.", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "d’Anconia Copper", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Gringotts", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Oscorp", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Nakatomi Trading", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Spacely Space Sprockets", clientMeta: "2 projects • 224 hrs. • since 2012")]
        
        self.dataController = DataController()
        self.initializeFetchedResultsController()
        
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
        
        let ClientNameLabel = cell.viewWithTag(1) as! UILabel
        ClientNameLabel.text = self.clients[indexPath.row].clientName
        
        let ClientMetaLabel = cell.viewWithTag(2) as! UILabel
        ClientMetaLabel.text = self.clients[indexPath.row].clientMeta
        
        cell.backgroundColor = UIColor.whiteColor()
        
        cell.contentView.frame = cell.bounds
        cell.contentView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        cell = collectionView.dequeueReusableCellWithReuseIdentifier("ClientCell", forIndexPath: indexPath) as UICollectionViewCell!
        
        self.configureCell(cell, indexPath: indexPath)
        
        return cell
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return clients.count
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
//            NewButton.layer.frame = CGRectMake(NewButton.layer.frame.minX, NewButton.layer.frame.minY, 50, 5)
            NewButton.layer.masksToBounds = true
            
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
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: "department.name", cacheName: "rootCache")
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
}
