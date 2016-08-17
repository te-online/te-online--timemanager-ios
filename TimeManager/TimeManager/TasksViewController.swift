//
//  TasksViewController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 12.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit
import CoreData

class TasksViewController: CardOfViewDeckController, NSFetchedResultsControllerDelegate, ProjectEditDelegate, ProjectDetailViewControllerDelegate, TaskEditDelegate {
    
    var backgroundController: UIViewController!
    
    var currentProject: ProjectObject!
    
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
        self.backgroundController = storyboard?.instantiateViewControllerWithIdentifier("TasksInfoBackground")
        (self.backgroundController as! ProjectDetailViewController).delegate = self
        
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
    
    @IBAction func saveTask(unwindSegue: UIStoryboardSegue) {
        (unwindSegue.sourceViewController as! TaskEditController).delegate = self
    }
    
    @IBAction func editProject(unwindSegue: UIStoryboardSegue) {
        (unwindSegue.sourceViewController as! ProjectEditController).delegate = self
    }
    
    @IBAction func cancel(unwindSegue: UIStoryboardSegue) {
        
    }
    
    /**
     *
     *   STORAGE ACTIONS
     *
     **/
    
    func editCurrentProject() {
        // Do something.
    }
    
    func deleteCurrentProject() {
        if currentProject != nil {
            let moc = self.dataController.managedObjectContext
            NSLog("current project " + String(self.currentProject))
            moc.deleteObject(self.currentProject)
            
            do {
                try moc.save()
                (self as CardOfViewDeckController).delegate?.didDeleteProject()
            } catch {
                fatalError("Failed to delete project: \(error)")
            }
        }
    }
    
    func saveNewTask(task: TaskEditController.Task) {
        NSLog("Task " + String(task))
        let entity = NSEntityDescription.entityForName("Task", inManagedObjectContext: dataController.managedObjectContext)
        let item = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: dataController.managedObjectContext)
        
        let now = NSDate()
        
        item.setValue(self.currentProject, forKey: "project")
        item.setValue(NSUUID().UUIDString, forKey: "uuid")
        item.setValue(self.currentProject.uuid, forKey: "project_uuid")
        item.setValue(task.name, forKey: "name")
        item.setValue(now, forKey: "changed")
        item.setValue(now, forKey: "created")
        
        do {
            try dataController.managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func saveNewProject(name: ProjectEditController.Project) {
        // Do nothing.
    }
    
    /**
     *
     *    PROJECT CONFIGURATION
     *
     **/
    
    func populateCurrentProjectDetails() {
        // Populate cells here
        
        let ProjectNameLabel = backgroundController!.view.viewWithTag(3) as! UILabel
        ProjectNameLabel.text = self.currentProject.name
        
        let ProjectPeriodLabel = backgroundController!.view.viewWithTag(6) as! UILabel
        ProjectPeriodLabel.text = self.dateFormatter.stringFromDate(self.currentProject.created!)
    }
    
    func setParentProject(project: ProjectObject) {
        NSLog("Setting project to " + String(project) + " current " + String(self.currentProject))
        self.currentProject = project
        self.initializeFetchedResultsControllerWithCurrentProject()
        self.populateCurrentProjectDetails()
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
        TaskMetaLabel.text = Task.getTotalHoursString()
        
        let TaskUnpaidLabel = cell.viewWithTag(3) as! UILabel
        TaskUnpaidLabel.text = "Unpaid will be visible here."
        
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
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("TaskCell", forIndexPath: indexPath) as UICollectionViewCell!
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
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "TasksHeadCell", forIndexPath: indexPath)
            
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
                
                // Update number of total client hours in header view.
                let clientHours = self.currentProject.client!.getTotalHoursString()
                let clientHoursLabel = headerView.viewWithTag(4) as! UILabel
                clientHoursLabel.text = clientHours
                
                // Update number of total project hours in header view.
                let projectHours = self.currentProject.getTotalHoursString()
                let projectHoursLabel = headerView.viewWithTag(5) as! UILabel
                projectHoursLabel.text = projectHours
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
    
    func initializeFetchedResultsControllerWithCurrentProject() {
        let request = NSFetchRequest(entityName: "Task")
        
        let createdSort = NSSortDescriptor(key: "created", ascending: true)
        request.sortDescriptors = [createdSort]
        
        let byProject = NSPredicate(format: "project = %@", currentProject)
        request.predicate = byProject
        
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
    
    func getCurrentTask() -> TaskObject {
        if self.currentSelection != nil {
            return (fetchedResultsController.objectAtIndexPath(self.currentSelection) as! TaskObject)
        } else {
            return TaskObject()
        }
    }

    
}