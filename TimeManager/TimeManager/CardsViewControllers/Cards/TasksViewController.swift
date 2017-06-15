//
//  TasksViewController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 12.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit
import CoreData

class TasksViewController: CardOfViewDeckController, NSFetchedResultsControllerDelegate, ProjectEditDelegate, ProjectDetailViewControllerDelegate, TaskCreateDelegate {
    
    var backgroundController: UIViewController!
    
    var currentProject: ProjectObject!
    
    var Colors = SharedColorPalette.sharedInstance
    
    var dataController: AppDelegate!
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    var currentSelection: IndexPath!
    
    var ProjectNameScrollLabel: UILabel!
    
    override func viewDidLoad() {
        // Let's get our data controller from the App Delegate.
        dataController = UIApplication.shared.delegate as! AppDelegate
        
        super.viewDidLoad()
        
        // Load all the nice child views we're going to use.
        self.backgroundController = storyboard?.instantiateViewController(withIdentifier: "TasksInfoBackground")
        (self.backgroundController as! ProjectDetailViewController).delegate = self
        
        // Show the first view.
        self.displayContentController(backgroundController!)
        
        self.collectionView!.frame = CGRect(x: 0, y: 30, width: self.view!.frame.width, height: self.collectionView!.frame.height - 30)
        self.collectionView!.backgroundColor = UIColor.clear
        self.view!.backgroundColor = UIColor.white
        
        self.ProjectNameScrollLabel = backgroundController!.view.viewWithTag(2) as! UILabel
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
    
    @IBAction func saveTask(_ unwindSegue: UIStoryboardSegue) {
        (unwindSegue.source as! TaskEditController).createDelegate = self
    }
    
    @IBAction func editProject(_ unwindSegue: UIStoryboardSegue) {
        // Do nothing. Just for unwinding.
    }
    
    @IBAction func cancel(_ unwindSegue: UIStoryboardSegue) {
        // Do nothing. Just for unwinding.
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
            self.currentProject.setValue("deleted", forKey: "commit")
            // Do this for children as well.
            for task in self.currentProject.tasks! {
                (task as! TaskObject).setValue("deleted", forKey: "commit")
                for time in (task as! TaskObject).times! {
                    (time as! TimeObject).setValue("deleted", forKey: "commit")
                }
            }
            
            do {
                try moc.save()
                (self as CardOfViewDeckController).delegate?.didDeleteProject()
            } catch {
                fatalError("Failed to delete project: \(error)")
            }
        }
    }
    
    func saveNewTask(_ task: TaskEditController.Task) {
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: dataController.managedObjectContext)
        let item = NSManagedObject(entity: entity!, insertInto: dataController.managedObjectContext)
        
        let now = Date()
        
        item.setValue(self.currentProject, forKey: "project")
        item.setValue(UUID().uuidString, forKey: "uuid")
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
    
    func editProject(_ project: ProjectEditController.Project) {
        let item = project.object
        
        let now = Date()
        
        item?.setValue(project.name, forKey: "name")
        item?.setValue(now, forKey: "changed")
        
        do {
            try dataController.managedObjectContext.save()
            self.populateCurrentProjectDetails()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
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
        
        self.ProjectNameScrollLabel.text = String(format: "%@ > %@", self.currentProject.client!.name!, self.currentProject.name!)
        
        let ProjectPeriodLabel = backgroundController!.view.viewWithTag(6) as! UILabel
        ProjectPeriodLabel.text = FormattingHelper.dateFormat(.dayMonthnameYear, date: self.currentProject.created!)
    }
    
    func setParentProject(_ project: ProjectObject) {
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
    
    func configureCell(_ cell: UICollectionViewCell, indexPath: IndexPath) {
        cell.backgroundColor = Colors.ProjectsCellBlue
        
        let correctedIndexPath = IndexPath(item: indexPath.item, section: indexPath.section - 1)
        let Task = fetchedResultsController.object(at: correctedIndexPath) as! TaskObject
        
        let TaskNameLabel = cell.viewWithTag(1) as! UILabel
        TaskNameLabel.text = Task.name
        
        let TaskMetaLabel = cell.viewWithTag(2) as! UILabel
        TaskMetaLabel.text = Task.getTotalHoursString()
        
        let TaskUnpaidLabel = cell.viewWithTag(3) as! UILabel
        TaskUnpaidLabel.text = "Unpaid will be visible here."
        
        if currentSelection != nil && (correctedIndexPath == currentSelection) {
            cell.contentView.backgroundColor = Colors.TasksCellActiveGreen
        } else {
            cell.contentView.backgroundColor = Colors.TasksCellGreen
        }
    }
    
    func configureInvisibleCell(_ cell: UICollectionViewCell, indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.isUserInteractionEnabled = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        
        if indexPath.section == 0 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "empty", for: indexPath) as UICollectionViewCell!
            self.configureInvisibleCell(cell, indexPath: indexPath)
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskCell", for: indexPath) as UICollectionViewCell!
            self.configureCell(cell, indexPath: indexPath)
        }
        
        return cell
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if fetchedResultsController == nil {
            return 2
        }
        return fetchedResultsController.sections!.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableView: UICollectionReusableView!
        reusableView = nil
        
        if(kind == UICollectionElementKindSectionHeader) {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "TasksHeadCell", for: indexPath)
            
            if(indexPath.section == 0) {
                headerView.backgroundColor = UIColor.clear
                headerView.alpha = 0
                headerView.isUserInteractionEnabled = false
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
    
    override func collectionView(_ myView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: self.view.frame.width, height: 70)
        }
        return super.getCellSize()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let correctedIndexPath = IndexPath(item: indexPath.item, section: indexPath.section - 1)
        self.currentSelection = correctedIndexPath
        self.collectionView!.reloadData()
        
        super.collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.currentSelection = nil
        self.collectionView!.reloadData()
    }
    
    override func scrollViewDidScroll(_ scrollView: (UIScrollView!)) {
        let scrollPosition = scrollView.contentOffset.y
        
        if scrollPosition >= 95 && self.ProjectNameScrollLabel.alpha < 1 {
            UIView.animate(withDuration: 0.25, animations: {() -> Void in
                self.ProjectNameScrollLabel.alpha = 1
            })
        } else if scrollPosition < 95 && self.ProjectNameScrollLabel.alpha == 1 {
            UIView.animate(withDuration: 0.25, animations: {() -> Void in
                self.ProjectNameScrollLabel.alpha = 0
            })
        }
    }
    
    /**
     *
     *   STICKY BACKGROUND CONTROLLER CONFIGURATION
     *
     **/
    
    func displayContentController(_ content: UIViewController!) {
        // Add the new view controller.
        self.addChildViewController(content!)
        // Make sure the view fits perfectly into our layout.
        content!.view.frame = self.visibleFrameForEmbeddedControllers()
        // Add the new view.
        self.view!.insertSubview(content!.view, belowSubview: self.collectionView!)
        // Tell the child that it now lives at their parents.
        content!.didMove(toParentViewController: self)
        content!.view.isUserInteractionEnabled = true
        
        
        let EditButton = content!.view.viewWithTag(4) as! UIButton
        EditButton.layer.borderColor = Colors.MediumGrey.cgColor
        
        let DeleteButton = content!.view.viewWithTag(5) as! UIButton
        DeleteButton.layer.borderColor = Colors.MediumRed.cgColor
        
        let CreateButton = content!.view.viewWithTag(7) as! UIButton
        CreateButton.layer.borderColor = Colors.MediumBlue.cgColor
    }
    
    func visibleFrameForEmbeddedControllers() -> CGRect {
        // Let's give them a rect, where the nav bar is still visible (Nav Bar is 86px in width and full height).
        let showRect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        return showRect
    }
    
    /**
     *
     *   FETCHED RESULTS CONTROLLER
     *
     **/
    
    func initializeFetchedResultsControllerWithCurrentProject() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        
        let createdSort = NSSortDescriptor(key: "created", ascending: true)
        request.sortDescriptors = [createdSort]
        
        let byProject = NSPredicate(format: "(project = %@) AND ((commit == nil) OR (commit != %@))", currentProject, "deleted")
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
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.collectionView?.reloadData()
    }
    
    /**
     *
     *   HELPER
     *
     **/
    
    func getCurrentTask() -> TaskObject {
        if self.currentSelection != nil {
            return (fetchedResultsController.object(at: self.currentSelection) as! TaskObject)
        } else {
            return TaskObject()
        }
    }

    
}
