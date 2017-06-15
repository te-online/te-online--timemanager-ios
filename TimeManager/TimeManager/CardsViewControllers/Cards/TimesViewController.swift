//
//  TimesViewController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 12.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit
import CoreData

class TimesViewController: CardOfViewDeckController, NSFetchedResultsControllerDelegate, TaskEditDelegate, TaskDetailViewControllerDelegate, TimeCreateDelegate, TimeEditDelegate {
    
    var backgroundController: UIViewController!
    
    var currentTask: TaskObject!
    
    var Colors = SharedColorPalette.sharedInstance
    
    var dataController: AppDelegate!
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    var currentSelection: IndexPath!
    
    var TaskNameScrollLabel: UILabel!
    
    override func viewDidLoad() {
        // Let's get our data controller from the App Delegate.
        dataController = UIApplication.shared.delegate as! AppDelegate
        
        super.viewDidLoad()
        
        // Load all the nice child views we're going to use.
        self.backgroundController = storyboard?.instantiateViewController(withIdentifier: "TimesInfoBackground")
        (self.backgroundController as! TaskDetailViewController).delegate = self
        
        // Show the first view.
        self.displayContentController(backgroundController!)
        
        self.collectionView!.frame = CGRect(x: 0, y: 30, width: self.view!.frame.width, height: self.collectionView!.frame.height - 30)
        self.collectionView!.backgroundColor = UIColor.clear
        self.view!.backgroundColor = UIColor.white
        
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
    
    @IBAction func saveTime(_ unwindSegue: UIStoryboardSegue) {
        (unwindSegue.source as! TimeEditController).createDelegate = self
    }
    
    @IBAction func editTask(_ unwindSegue: UIStoryboardSegue) {
        // Do nothing. Just for unwinding.
    }
    
    @IBAction func cancel(_ unwindSegue: UIStoryboardSegue) {
        // Do nothing. Just for unwinding.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTime" {
            (segue.destination as! TimeEditController).editDelegate = self
            if self.currentSelection != nil {
                (segue.destination as! TimeEditController).editTimeObject = (fetchedResultsController.object(at: self.currentSelection) as! TimeObject)
            }
            (segue.destination as! TimeEditController).currentTaskObject = self.currentTask
        }
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
            // Do this for children as well.
            for time in self.currentTask.times! {
                (time as! TimeObject).setValue("deleted", forKey: "commit")
            }
            
            do {
                try moc.save()
                (self as CardOfViewDeckController).delegate?.didDeleteTask()
            } catch {
                fatalError("Failed to delete task: \(error)")
            }
        }
    }
    
    func saveNewTime(_ time: TimeEditController.Time) {
        let entity = NSEntityDescription.entity(forEntityName: "Time", in: dataController.managedObjectContext)
        let item = NSManagedObject(entity: entity!, insertInto: dataController.managedObjectContext)
        
        let now = Date()
        
        item.setValue(self.currentTask, forKey: "task")
        item.setValue(UUID().uuidString, forKey: "uuid")
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
    
    func editTask(_ task: TaskEditController.Task) {
        let item = task.object
        
        let now = Date()
        
        item?.setValue(task.name, forKey: "name")
        item?.setValue(now, forKey: "changed")
        
        do {
            try dataController.managedObjectContext.save()
            self.populateCurrentTaskDetails()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func editTime(_ time: TimeEditController.Time) {
        let item = time.object
        
        let now = Date()
        
        item?.setValue(time.note, forKey: "note")
        item?.setValue(time.start, forKey: "start")
        item?.setValue(time.end, forKey: "end")
        item?.setValue(now, forKey: "changed")
        
        do {
            try dataController.managedObjectContext.save()
            self.collectionView!.reloadData()
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
        ProjectPeriodLabel.text = FormattingHelper.dateFormat(.dayMonthnameYear, date: self.currentTask.created!)
    }
    
    func setParentTask(_ task: TaskObject) {
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
    
    func configureCell(_ cell: UICollectionViewCell, indexPath: IndexPath) {
        cell.backgroundColor = Colors.ProjectsCellBlue
        
        let correctedIndexPath = IndexPath(item: indexPath.item, section: indexPath.section - 1)
        let Time = fetchedResultsController.object(at: correctedIndexPath) as! TimeObject
        
        let TimeDurationLabel = cell.viewWithTag(1) as! UILabel
        TimeDurationLabel.text = Time.getHoursString()
        
        let TimeMetaLabel = cell.viewWithTag(2) as! UILabel
        TimeMetaLabel.text = Time.getDateString()
        
        // TODO
        // Payment tracking is not implemented, yet.
        let TimeUnpaidLabel = cell.viewWithTag(3) as! UILabel
        TimeUnpaidLabel.text = "Unpaid"
        
        let TimeSpanLabel = cell.viewWithTag(4) as! UILabel
        TimeSpanLabel.text = Time.getTimeSpanString()
        
        let TimeNoteLabel = cell.viewWithTag(5) as! UILabel
        TimeNoteLabel.text = Time.note
        
        if currentSelection != nil && (indexPath == currentSelection) {
            cell.contentView.backgroundColor = Colors.VeryLightGrey
        } else {
            cell.contentView.backgroundColor = UIColor.white
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
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeCell", for: indexPath) as UICollectionViewCell!
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
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "TimesHeadCell", for: indexPath)
            
            if(indexPath.section == 0) {
                headerView.backgroundColor = UIColor.clear
                headerView.alpha = 0
                headerView.isUserInteractionEnabled = false
            } else {
                headerView.backgroundColor = UIColor.white
                
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
        
        if scrollPosition >= 95 && self.TaskNameScrollLabel.alpha < 1 {
            UIView.animate(withDuration: 0.25, animations: {() -> Void in
                self.TaskNameScrollLabel.alpha = 1
            })
        } else if scrollPosition < 95 && self.TaskNameScrollLabel.alpha == 1 {
            UIView.animate(withDuration: 0.25, animations: {() -> Void in
                self.TaskNameScrollLabel.alpha = 0
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
        let showRect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 0.6)
        return showRect
    }
    
    /**
     *
     *   FETCHED RESULTS CONTROLLER
     *
     **/
    
    func initializeFetchedResultsControllerWithCurrentTask() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Time")
        
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
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.collectionView?.reloadData()
    }
    
    /**
     *
     *   HELPER
     *
     **/
    
    func getCurrentTime() -> TimeObject {
        if self.currentSelection != nil {
            return (fetchedResultsController.object(at: self.currentSelection) as! TimeObject)
        } else {
            return TimeObject()
        }
    }
    
}
