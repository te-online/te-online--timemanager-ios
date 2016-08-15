//
//  ProjectsViewController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 12.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit
import CoreData

class ProjectsViewController: CardOfViewDeckController, NSFetchedResultsControllerDelegate, ProjectEditDelegate, ClientEditDelegate, ClientDetailViewControllerDelegate {
    
    var backgroundController: UIViewController!
    
//    struct newClient {
//        var name: String!
//        var sinceDate: String!
//        var address: String!
//        var contacts: [String]!
//        var note: String!
//        var totalHours: Double!
//    }
//    
//    struct Client {
//        var clientName: String!
//        var clientMeta: String!
//    }
//    
//    struct Project {
//        var name: String!
//        var numTasks: Int!
//        var numHours: Double!
//        var numHoursUnpaid: Double!
//        var numHoursNInvoiced: Double!
//    }
    
    var currentClientId: Int = -1
    
    var cellColor: UIColor!
    var activeColor: UIColor!
    
    var Colors = SharedColorPalette.sharedInstance
    
    var dataController: AppDelegate!
    
    var fetchedResultsController: NSFetchedResultsController!
    
    var dateFormatter: NSDateFormatter!
    
    override func viewDidLoad() {
        // Let's get our data controller from the App Delegate.
        dataController = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // Let's create a nice date format.
        dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .NoStyle
        
        super.viewDidLoad()
        
        // Load all the nice child views we're going to use.
        self.backgroundController = storyboard?.instantiateViewControllerWithIdentifier("ProjectsInfoBackground")
        (self.backgroundController as! ClientDetailViewController).delegate = self
        
        // Show the first view.
        self.displayContentController(backgroundController!)
        
        self.collectionView!.frame = CGRect(x: 0, y: 30, width: self.view!.frame.width, height: self.collectionView!.frame.height - 30)
        self.collectionView!.backgroundColor = UIColor.clearColor()
        self.view!.backgroundColor = UIColor.whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveProject(unwindSegue: UIStoryboardSegue) {
        (unwindSegue.sourceViewController as! ProjectEditController).delegate = self
    }
    
    @IBAction func editClient(unwindSegue: UIStoryboardSegue) {
        (unwindSegue.sourceViewController as! ClientEditController).delegate = self
    }
    
    @IBAction func cancel(unwindSegue: UIStoryboardSegue) {
        
    }
    
    func editCurrentClient() {
        // Do something.
    }
    
    func deleteCurrentClient() {
        if currentClientId > -1 {
            let request = NSFetchRequest(entityName: "Client")
            
            let byClientId = NSPredicate(format: "id = %@", String(currentClientId))
            request.predicate = byClientId
            
            let moc = self.dataController.managedObjectContext
            
            do {
                let deleteables = try moc.executeFetchRequest(request)
                for deleteable in deleteables {
                    moc.deleteObject(deleteable as! NSManagedObject)
                    self.collectionView!.reloadData()
                }
            } catch {
                fatalError("Failed to fetch details for client: \(error)")
            }
        }
        
    }
    
    func saveNewProject(project: ProjectEditController.Project) {
        NSLog("Project " + String(project))
        let entity = NSEntityDescription.entityForName("Project", inManagedObjectContext: dataController.managedObjectContext)
        let item = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: dataController.managedObjectContext)
        
        item.setValue(1, forKey: "id")
        item.setValue(currentClientId, forKey: "client_id")
        item.setValue(project.name, forKey: "name")
        item.setValue(NSDate(), forKey: "changed")
        item.setValue(NSDate(), forKey: "created")
        
        do {
            try dataController.managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func saveNewClient(name: ClientEditController.Client) {
        // Do nothing.
    }
    
    func initializeFetchedResultsControllerWithClientId(clientId: Int) {
        let request = NSFetchRequest(entityName: "Project")
        
        let createdSort = NSSortDescriptor(key: "created", ascending: true)
        request.sortDescriptors = [createdSort]
        
        let byClientId = NSPredicate(format: "client_id = %@", String(clientId))
        request.predicate = byClientId
        
        let moc = self.dataController.managedObjectContext
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    func fetchDetailsForClient(clientId: Int) {
        let request = NSFetchRequest(entityName: "Client")
        
        let byClientId = NSPredicate(format: "id = %@", String(clientId))
        request.predicate = byClientId
        
        let moc = self.dataController.managedObjectContext
        
        do {
            let clientDetails = try moc.executeFetchRequest(request)
            self.populateClientDetails(clientDetails as! [ClientObject])
        } catch {
            fatalError("Failed to fetch details for client: \(error)")
        }
    }
    
    func populateClientDetails(clientObjects: [ClientObject]) {
        // Populate cells here
        NSLog(String(clientObjects))
        if clientObjects.count > 0 {
            let currentClient = clientObjects[0]
            
            let ClientNameLabel = backgroundController!.view.viewWithTag(4) as! UILabel
            ClientNameLabel.text = currentClient.name
            
            let ClientSinceLabel = backgroundController!.view.viewWithTag(7) as! UILabel
            ClientSinceLabel.text = self.dateFormatter.stringFromDate(currentClient.created!)
            
            let ClientAddressLabel = backgroundController!.view.viewWithTag(8) as! UILabel
            ClientAddressLabel.text = (currentClient.street! + "\n" + currentClient.postcode! + " " + currentClient.city!)
            
            let ClientNoteLabel = backgroundController!.view.viewWithTag(11) as! UILabel
            ClientNoteLabel.text = currentClient.note
        }
        
//        if clientObjects as ProjectObject
    }
    
    func configureCell(cell: UICollectionViewCell, indexPath: NSIndexPath) {
        cell.backgroundColor = Colors.ProjectsCellBlue
        
        let correctedIndexPath = NSIndexPath(forItem: indexPath.item, inSection: indexPath.section - 1)
        let Project = fetchedResultsController.objectAtIndexPath(correctedIndexPath) as! ProjectObject
        
        let ProjectNameLabel = cell.viewWithTag(1) as! UILabel
        ProjectNameLabel.text = Project.name
        
        let ProjectMetaLabel = cell.viewWithTag(2) as! UILabel
        ProjectMetaLabel.text = "Projectinfo goes here."
    }
    
    func configureInvisibleCell(cell: UICollectionViewCell, indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
        cell.userInteractionEnabled = false
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        
        if indexPath.section == 0 {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("empty", forIndexPath: indexPath) as UICollectionViewCell!
            self.configureInvisibleCell(cell, indexPath: indexPath)
        } else {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("ProjectCell", forIndexPath: indexPath) as UICollectionViewCell!
            self.configureCell(cell, indexPath: indexPath)
        }
        
        return cell
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if fetchedResultsController == nil {
            return 2
        }
        return fetchedResultsController.sections!.count + 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(section == 0) {
            return 1
        } else {
            if fetchedResultsController == nil {
                return 0
            } else {
                let correctedSection = section - 1
                return fetchedResultsController.sections![correctedSection].numberOfObjects
            }
        }
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        var reusableView: UICollectionReusableView!
        reusableView = nil
        
        if(kind == UICollectionElementKindSectionHeader) {
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "ProjectsHeadCell", forIndexPath: indexPath)
            
            if(indexPath.section == 0) {
                headerView.backgroundColor = UIColor.clearColor()
                headerView.alpha = 0
                headerView.userInteractionEnabled = false
            } else {
                headerView.backgroundColor = Colors.ProjectsCellBlue
                
                // Update number of items in header view.
                let itemCount = (fetchedResultsController != nil && fetchedResultsController.sections!.count > 0) ? fetchedResultsController.sections![0].numberOfObjects : 0
                let itemCountLabel = headerView.viewWithTag(5) as! UILabel
                itemCountLabel.text = "#" + String(itemCount)
            }
            
            reusableView = headerView
        }
        
        return reusableView
    }
    
    override func collectionView(myView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: self.view.frame.width, height: 150)
        }
        return super.getCellSize()
    }
    
    func setParentClientId(clientId: Int) {
        NSLog("Setting client id " + String(clientId))
        currentClientId = clientId
        self.initializeFetchedResultsControllerWithClientId(clientId)
        self.fetchDetailsForClient(clientId)
        self.collectionView?.reloadData()
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
        
        let EditButton = content!.view.viewWithTag(5) as! UIButton
        EditButton.layer.borderColor = Colors.MediumGrey.CGColor
        
        let DeleteButton = content!.view.viewWithTag(6) as! UIButton
        DeleteButton.layer.borderColor = Colors.MediumRed.CGColor
    }
    
    func visibleFrameForEmbeddedControllers() -> CGRect {
        // Let's give them a rect, where the nav bar is still visible (Nav Bar is 86px in width and full height).
        let showRect = CGRect(x:0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 0.6)
        return showRect
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        super.collectionView(collectionView, didSelectItemAtIndexPath: indexPath)
        let cell: UICollectionViewCell! = collectionView.cellForItemAtIndexPath(indexPath)
        if cell != nil {
            cell.contentView.backgroundColor = Colors.ProjectsCellActiveBlue
        }
    }
    
//    override func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
//        let cell: UICollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath)!
//        cell.contentView.backgroundColor = Colors.ProjectsCellActiveBlue
//    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell: UICollectionViewCell! = collectionView.cellForItemAtIndexPath(indexPath)
        if cell != nil {
            cell.contentView.backgroundColor = Colors.ProjectsCellBlue
        }
    }
    
//    override func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
//        let cell: UICollectionViewCell = self.collectionView!.cellForItemAtIndexPath(indexPath)!
//        cell.contentView.backgroundColor = Colors.ProjectsCellBlue
//    }
    
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
