//
//  TimesViewController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 12.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit
import CoreData

class TimesViewController: CardOfViewDeckController, NSFetchedResultsControllerDelegate, TaskEditDelegate, TaskDetailViewControllerDelegate, TimeCreateDelegate {
    
    var backgroundController: UIViewController!
    
    var currentTask: TaskObject!
    
    var Colors = SharedColorPalette.sharedInstance
    
    var dataController: AppDelegate!
    
    var fetchedResultsController: NSFetchedResultsController!
    
    var dateFormatter: NSDateFormatter!
    
    var currentSelection: NSIndexPath!
    
    var TaskNameScrollLabel: UILabel!
    
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
        
        self.TaskNameScrollLabel = backgroundController!.view.viewWithTag(2) as! UILabel
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
        (unwindSegue.sourceViewController as! TimeEditController).createDelegate = self
    }
    
    @IBAction func editTask(unwindSegue: UIStoryboardSegue) {
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
    
    func deleteCurrentTask() {
        if self.currentTask != nil {
            let moc = self.dataController.managedObjectContext
            self.currentTask.setValue("deleted", forKey: "commit")
            
            do {
                try moc.save()
                (self as CardOfViewDeckController).delegate?.didDeleteTask()
            } catch {
                fatalError("Failed to delete task: \(error)")
            }
        }
    }
    
    func saveNewTime(time: TimeEditController.Time) {
        NSLog("Time " + String(time))
        let entity = NSEntityDescription.entityForName("Time", inManagedObjectContext: dataController.managedObjectContext)
        let item = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: dataController.managedObjectContext)
        
        let now = NSDate()
        
        item.setValue(self.currentTask, forKey: "task")
        item.setValue(NSUUID().UUIDString, forKey: "uuid")
        item.setValue(self.currentTask.uuid, forKey: "task_uuid")
        item.setValue(time.start, forKey: "start")
        item.setValue(time.end, forKey: "end")
        item.setValue(time.note, forKey: "note")
        item.setValue(now, forKey: "changed")
        item.setValue(now, forKey: "created")
        
        do {
            try dataController.managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func editTask(task: TaskEditController.Task) {
        let item = task.object
        
        let now = NSDate()
        
        item.setValue(task.name, forKey: "name")
        item.setValue(now, forKey: "changed")
        
        do {
            try dataController.managedObjectContext.save()
            self.populateCurrentTaskDetails()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    /**
     *
     *    TIME CONFIGURATION
     *
     **/
    
    func populateCurrentTaskDetails() {
        // Populate cells here
        
        let TaskNameLabel = backgroundController!.view.viewWithTag(3) as! UILabel
        TaskNameLabel.text = self.currentTask.name
        
        self.TaskNameScrollLabel.text = String(format: "%@ > %@ > %@", self.currentTask.project!.client!.name!, self.currentTask.project!.name!, self.currentTask.name!)
        
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
        let Time = fetchedResultsController.objectAtIndexPath(correctedIndexPath) as! TimeObject
        
        let TimeDurationLabel = cell.viewWithTag(1) as! UILabel
        TimeDurationLabel.text = Time.getHoursString()
        
        let TimeMetaLabel = cell.viewWithTag(2) as! UILabel
        TimeMetaLabel.text = Time.getDateString()
        
        let TimeUnpaidLabel = cell.viewWithTag(3) as! UILabel
        TimeUnpaidLabel.text = "Unpaid"
        
        let TimeSpanLabel = cell.viewWithTag(4) as! UILabel
        TimeSpanLabel.text = Time.getTimeSpanString()
        
        let TimeNoteLabel = cell.viewWithTag(5) as! UILabel
        TimeNoteLabel.text = Time.note
        
        if currentSelection != nil && indexPath.isEqual(currentSelection) {
            cell.contentView.backgroundColor = Colors.VeryLightGrey
        } else {
            cell.contentView.backgroundColor = UIColor.whiteColor()
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
                headerView.backgroundColor = UIColor.whiteColor()
                
                // Update number of items in header view.
                let itemCount = (fetchedResultsController != nil && fetchedResultsController.sections!.count > 0) ? fetchedResultsController.sections![0].numberOfObjects : 0
                let itemCountLabel = headerView.viewWithTag(2) as! UILabel
                itemCountLabel.text = "#" + String(itemCount)
                
                // Update number of total client hours in header view.
                let clientHours = self.currentTask.project!.client!.getTotalHoursString()
                let clientHoursLabel = headerView.viewWithTag(4) as! UILabel
                clientHoursLabel.text = clientHours
                
                // Update number of total project hours in header view.
                let projectHours = self.currentTask.project!.getTotalHoursString()
                let projectHoursLabel = headerView.viewWithTag(6) as! UILabel
                projectHoursLabel.text = projectHours
                
                // Update number of total task hours in header view.
                let taskHours = self.currentTask.getTotalHoursString()
                let taskHoursLabel = headerView.viewWithTag(8) as! UILabel
                taskHoursLabel.text = taskHours
            }
            
            reusableView = headerView
        }
        
        return reusableView
    }
    
    override func collectionView(myView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: self.view.frame.width, height: 70)
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
    
    override func scrollViewDidScroll(scrollView: (UIScrollView!)) {
        let scrollPosition = scrollView.contentOffset.y
        
        if scrollPosition >= 95 && self.TaskNameScrollLabel.alpha < 1 {
            UIView.animateWithDuration(0.25, animations: {() -> Void in
                self.TaskNameScrollLabel.alpha = 1
            })
        } else if scrollPosition < 95 && self.TaskNameScrollLabel.alpha == 1 {
            UIView.animateWithDuration(0.25, animations: {() -> Void in
                self.TaskNameScrollLabel.alpha = 0
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
        
        // We don't need entries that are flagged for deletion. However, commit will only compare to a string if not nil, but nil is okay, too.
        let byTask = NSPredicate(format: "(task = %@) AND ((commit == nil) OR (commit != %@))", self.currentTask, "deleted")
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
