//
//  ProjectsViewController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 12.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit
import CoreData

class ProjectsViewController: CardOfViewDeckController, NSFetchedResultsControllerDelegate, ProjectCreateDelegate, ClientEditDelegate, ClientDetailViewControllerDelegate {
    
    var backgroundController: UIViewController!
    
    var currentClient: ClientObject!
    
    var Colors = SharedColorPalette.sharedInstance
    
    var dataController: AppDelegate!
    
    var fetchedResultsController: NSFetchedResultsController!
    
    var currentSelection: NSIndexPath!
    
    var ClientNameScrollLabel: UILabel!
    
    override func viewDidLoad() {
        // Let's get our data controller from the App Delegate.
        dataController = UIApplication.sharedApplication().delegate as! AppDelegate
        
        super.viewDidLoad()
        
        // Load all the nice child views we're going to use.
        self.backgroundController = storyboard?.instantiateViewControllerWithIdentifier("ProjectsInfoBackground")
        (self.backgroundController as! ClientDetailViewController).delegate = self
        
        // Show the first view.
        self.displayContentController(backgroundController!)
        
        self.collectionView!.frame = CGRect(x: 0, y: 30, width: self.view!.frame.width, height: self.collectionView!.frame.height - 30)
        self.collectionView!.backgroundColor = UIColor.clearColor()
        self.view!.backgroundColor = UIColor.whiteColor()
        
        self.ClientNameScrollLabel = backgroundController!.view.viewWithTag(3) as! UILabel
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
    
    @IBAction func saveProject(unwindSegue: UIStoryboardSegue) {
        (unwindSegue.sourceViewController as! ProjectEditController).createDelegate = self
    }
    
    @IBAction func editClient(unwindSegue: UIStoryboardSegue) {
        // Do nothing. Just for unwinding.
    }
    
    @IBAction func cancel(unwindSegue: UIStoryboardSegue) {
        // Do nothing. Just for unwinding.
    }
    
    /**
     *
     *   STORAGE ACTIONS
     *
     **/
    
    func deleteCurrentClient() {
        if currentClient != nil {
            let moc = self.dataController.managedObjectContext
            self.currentClient.setValue("deleted", forKey: "commit")
            // Do this for children as well.
            for project in self.currentClient.projects! {
                (project as! ProjectObject).setValue("deleted", forKey: "commit")
                for task in (project as! ProjectObject).tasks! {
                    (task as! TaskObject).setValue("deleted", forKey: "commit")
                    for time in (task as! TaskObject).times! {
                        (time as! TimeObject).setValue("deleted", forKey: "commit")
                    }
                }
            }
            
            do {
                try moc.save()
                (self as CardOfViewDeckController).delegate?.didDeleteClient()
            } catch {
                fatalError("Failed to delete client: \(error)")
            }
        }
    }
    
    func saveNewProject(project: ProjectEditController.Project) {
        let entity = NSEntityDescription.entityForName("Project", inManagedObjectContext: dataController.managedObjectContext)
        let item = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: dataController.managedObjectContext)
        
        let now = NSDate()
        
        item.setValue(currentClient, forKey: "client")
        item.setValue(NSUUID().UUIDString, forKey: "uuid")
        item.setValue(currentClient.uuid, forKey: "client_uuid")
        item.setValue(project.name, forKey: "name")
        item.setValue(now, forKey: "changed")
        item.setValue(now, forKey: "created")
        
        do {
            try dataController.managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func editClient(client: ClientEditController.Client) {
        let item = client.object
        
        let now = NSDate()
        
        item.setValue(client.name, forKey: "name")
        item.setValue(client.street, forKey: "street")
        item.setValue(client.postcode, forKey: "postcode")
        item.setValue(client.city, forKey: "city")
        item.setValue(client.note, forKey: "note")
        item.setValue(now, forKey: "changed")
        
        do {
            try dataController.managedObjectContext.save()
            self.populateCurrentClientDetails()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    /**
     *
     *    CLIENT CONFIGURATION
     *
     **/
    
    func populateCurrentClientDetails() {
        // Populate cells here
        
        let ClientNameLabel = backgroundController!.view.viewWithTag(4) as! UILabel
        ClientNameLabel.text = currentClient.name
        
        self.ClientNameScrollLabel.text = currentClient.name
        
        let ClientSinceLabel = backgroundController!.view.viewWithTag(7) as! UILabel
        ClientSinceLabel.text = FormattingHelper.dateFormat(.DayMonthnameYear, date: currentClient.created!)
        
        let ClientAddressLabel = backgroundController!.view.viewWithTag(8) as! UILabel
        ClientAddressLabel.text = (currentClient.street! + "\n" + currentClient.postcode! + " " + currentClient.city!)
        
        let ClientNoteLabel = backgroundController!.view.viewWithTag(11) as! UILabel
        ClientNoteLabel.text = currentClient.note
    }
    
    func setParentClient(client: ClientObject) {
        self.currentClient = client
        self.initializeFetchedResultsControllerWithCurrentClient()
        self.populateCurrentClientDetails()
        self.collectionView?.reloadData()
    }
    
    /**
     *
     *   COLLECTION VIEW
     *
     **/
    
    func configureCell(cell: UICollectionViewCell, indexPath: NSIndexPath) {
        cell.backgroundColor = Colors.ProjectsCellBlue
        
        let correctedIndexPath = NSIndexPath(forItem: indexPath.item, inSection: indexPath.section - 1)
        let Project = fetchedResultsController.objectAtIndexPath(correctedIndexPath) as! ProjectObject
        
        let ProjectNameLabel = cell.viewWithTag(1) as! UILabel
        ProjectNameLabel.text = Project.name
        
        let ProjectMetaLabel = cell.viewWithTag(2) as! UILabel
        ProjectMetaLabel.text = Project.getMetaString()
        
        if currentSelection != nil && correctedIndexPath.isEqual(currentSelection) {
            cell.contentView.backgroundColor = Colors.ProjectsCellActiveBlue
        } else {
            cell.contentView.backgroundColor = Colors.ProjectsCellBlue
        }
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
                let itemCountLabel = headerView.viewWithTag(2) as! UILabel
                itemCountLabel.text = "#" + String(itemCount)
                
                // Update number of total client hours in header view.
                let clientHours = self.currentClient.getTotalHoursString()
                let clientHoursLabel = headerView.viewWithTag(4) as! UILabel
                clientHoursLabel.text = clientHours
            }
            
            reusableView = headerView
        }
        
        return reusableView
    }
    
    override func collectionView(myView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: self.view.frame.width, height: 120)
        }
        
        return super.getCellSize()
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let correctedIndexPath = NSIndexPath(forItem: indexPath.item, inSection: indexPath.section - 1)
        self.currentSelection = correctedIndexPath
        self.collectionView!.reloadData()
        
        super.collectionView(collectionView, didSelectItemAtIndexPath: indexPath)
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        self.currentSelection = nil
        self.collectionView!.reloadData()
    }
    
    func scrolledTo(position: UICollectionViewScrollPosition) {
        //
    }
    
    override func scrollViewDidScroll(scrollView: (UIScrollView!)) {
        let scrollPosition = scrollView.contentOffset.y
        
        if scrollPosition >= 145 && self.ClientNameScrollLabel.alpha < 1 {
            UIView.animateWithDuration(0.25, animations: {() -> Void in
                self.ClientNameScrollLabel.alpha = 1
            })
        } else if scrollPosition < 145 && self.ClientNameScrollLabel.alpha == 1 {
            UIView.animateWithDuration(0.25, animations: {() -> Void in
                self.ClientNameScrollLabel.alpha = 0
            })
        }
    }
    
    /**
     *
     *   STICKY BACKGROUND CONTROLLER CONFIGURATION
     *
     **/
    
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
        
        let CreateButton = content!.view.viewWithTag(12) as! UIButton
        CreateButton.layer.borderColor = Colors.MediumBlue.CGColor
    }
    
    func visibleFrameForEmbeddedControllers() -> CGRect {
        // Let's give them a rect, where the nav bar is still visible (Nav Bar is 86px in width and full height).
        let showRect = CGRect(x:0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        return showRect
    }
    
    /**
     *
     *   FETCHED RESULTS CONTROLLER
     *
     **/
    
    func initializeFetchedResultsControllerWithCurrentClient() {
        let request = NSFetchRequest(entityName: "Project")
        
        let createdSort = NSSortDescriptor(key: "created", ascending: true)
        request.sortDescriptors = [createdSort]
        
        let byClient = NSPredicate(format: "(client = %@) AND ((commit == nil) OR (commit != %@))", currentClient, "deleted")
        request.predicate = byClient
        
        let moc = self.dataController.managedObjectContext
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
       
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.collectionView?.reloadData()
    }
    
    /**
     *
     *   HELPER
     *
     **/
    
    func getCurrentProject() -> ProjectObject {
        if self.currentSelection != nil {
            return (fetchedResultsController.objectAtIndexPath(self.currentSelection) as! ProjectObject)
        } else {
            return ProjectObject()
        }
    }
    
}