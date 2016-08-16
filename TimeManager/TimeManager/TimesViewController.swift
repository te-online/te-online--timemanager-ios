//
//  TimesViewController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 12.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit
import CoreData

class TimesViewController: CardOfViewDeckController, NSFetchedResultsControllerDelegate, TaskEditDelegate, TaskDetailViewControllerDelegate, TimeEditDelegate {
    
    var backgroundController: UIViewController!
    
    var currentTask: TaskObject!
    
    var Colors = SharedColorPalette.sharedInstance
    
    var dataController: AppDelegate!
    
    var fetchedResultsController: NSFetchedResultsController!
    
    var dateFormatter: NSDateFormatter!
    
    var currentSelection: NSIndexPath!
    
    override func viewDidLoad() {
        // Let's get our data controller from the App Delegate.
        dataController = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // Let's create a nice date format.
        dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .NoStyle
        
        super.viewDidLoad()
        
        // Load all the nice child views we're going to use.
        self.backgroundController = storyboard?.instantiateViewControllerWithIdentifier("TimesInfoBackground")
        (self.backgroundController as! TaskDetailViewController).delegate = self
        
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
    
    /**
     *
     *   UNWIND BUTTON ACTIONS
     *
     **/
    
    @IBAction func saveTime(unwindSegue: UIStoryboardSegue) {
        (unwindSegue.sourceViewController as! TimeEditController).delegate = self
    }
    
    @IBAction func editTask(unwindSegue: UIStoryboardSegue) {
        (unwindSegue.sourceViewController as! TaskEditController).delegate = self
    }
    
    @IBAction func cancel(unwindSegue: UIStoryboardSegue) {
        
    }
    
    /**
     *
     *   STORAGE ACTIONS
     *
     **/
    
    func editCurrentTask() {
        // Do something.
    }
    
    func deleteCurrentTask() {
        if self.currentTask != nil {
            let moc = self.dataController.managedObjectContext
            moc.deleteObject(self.currentTask)
            
            do {
                try moc.save()
            } catch {
                fatalError("Failed to delete task: \(error)")
            }
        }
    }
    
    func saveNewTime(time: TimeEditController.Time) {
        NSLog("Time " + String(time))
        let entity = NSEntityDescription.entityForName("Time", inManagedObjectContext: dataController.managedObjectContext)
        let item = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: dataController.managedObjectContext)
        
        item.setValue(self.currentTask, forKey: "task")
        item.setValue(NSUUID().UUIDString, forKey: "uuid")
        item.setValue(self.currentTask.uuid, forKey: "task_uuid")
        item.setValue(time.name, forKey: "name")
        item.setValue(time.start, forKey: "start")
        item.setValue(time.end, forKey: "end")
        item.setValue(time.note, forKey: "note")
        item.setValue(NSDate(), forKey: "changed")
        item.setValue(NSDate(), forKey: "created")
        
        do {
            try dataController.managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func saveNewTask(name: TaskEditController.Task) {
        // Do nothing.
    }
    
    /**
     *
     *    TIME CONFIGURATION
     *
     **/
    
    func populateCurrentTaskDetails() {
        // Populate cells here
        
        let ProjectNameLabel = backgroundController!.view.viewWithTag(3) as! UILabel
        ProjectNameLabel.text = self.currentTask.name
        
        let ProjectPeriodLabel = backgroundController!.view.viewWithTag(6) as! UILabel
        ProjectPeriodLabel.text = self.dateFormatter.stringFromDate(self.currentTask.created!)
    }
    
    func setParentTask(task: TaskObject) {
//        NSLog("Setting task to " + String(project) + " current " + String(self.currentProject))
        self.currentTask = task
        self.initializeFetchedResultsControllerWithCurrentTask()
        self.populateCurrentTaskDetails()
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
        let Task = fetchedResultsController.objectAtIndexPath(correctedIndexPath) as! TaskObject
        
        let TaskNameLabel = cell.viewWithTag(1) as! UILabel
        TaskNameLabel.text = Task.name
        
        let TaskMetaLabel = cell.viewWithTag(2) as! UILabel
        TaskMetaLabel.text = "Taskinfo goes here."
        
        let TaskUnpaidLabel = cell.viewWithTag(3) as! UILabel
        TaskUnpaidLabel.text = "Unpaid hours go here."
        
        if currentSelection != nil && correctedIndexPath.isEqual(currentSelection) {
            cell.contentView.backgroundColor = Colors.TasksCellActiveGreen
        } else {
            cell.contentView.backgroundColor = Colors.TasksCellGreen
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
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("TimeCell", forIndexPath: indexPath) as UICollectionViewCell!
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
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "TimesHeadCell", forIndexPath: indexPath)
            
            if(indexPath.section == 0) {
                headerView.backgroundColor = UIColor.clearColor()
                headerView.alpha = 0
                headerView.userInteractionEnabled = false
            } else {
                headerView.backgroundColor = Colors.TasksCellGreen
                
                // Update number of items in header view.
                let itemCount = (fetchedResultsController != nil && fetchedResultsController.sections!.count > 0) ? fetchedResultsController.sections![0].numberOfObjects : 0
                let itemCountLabel = headerView.viewWithTag(7) as! UILabel
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
        // Tell the child that it now lives at their parents.
        content!.didMoveToParentViewController(self)
        content!.view.userInteractionEnabled = true
        
        let EditButton = content!.view.viewWithTag(4) as! UIButton
        EditButton.layer.borderColor = Colors.MediumGrey.CGColor
        
        let DeleteButton = content!.view.viewWithTag(5) as! UIButton
        DeleteButton.layer.borderColor = Colors.MediumRed.CGColor
        
        let CreateButton = content!.view.viewWithTag(7) as! UIButton
        CreateButton.layer.borderColor = Colors.MediumBlue.CGColor
    }
    
    func visibleFrameForEmbeddedControllers() -> CGRect {
        // Let's give them a rect, where the nav bar is still visible (Nav Bar is 86px in width and full height).
        let showRect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 0.6)
        return showRect
    }
    
    /**
     *
     *   FETCHED RESULTS CONTROLLER
     *
     **/
    
    func initializeFetchedResultsControllerWithCurrentTask() {
        let request = NSFetchRequest(entityName: "Time")
        
        let createdSort = NSSortDescriptor(key: "created", ascending: true)
        request.sortDescriptors = [createdSort]
        
        let byTask = NSPredicate(format: "task = %@", self.currentTask)
        request.predicate = byTask
        
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
    
}
