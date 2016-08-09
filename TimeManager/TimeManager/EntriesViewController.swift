//
//  EntriesViewController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 09.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

class EntriesViewController: UIViewController, UITableViewDelegate {
    
    struct Selection {
        var clientId: Int!
        var projectId: Int!
        var taskId: Int!
    }
    
    var currentSelection: Selection!
    
    var clientsController: UITableViewController!
    var projectsController: UITableViewController!
    var tasksController: UITableViewController!
    var timesController: UITableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load all the nice child views we're going to use.
        self.clientsController = storyboard?.instantiateViewControllerWithIdentifier("ClientsViewController") as! UITableViewController
        self.projectsController = storyboard?.instantiateViewControllerWithIdentifier("ProjectsViewController") as! UITableViewController
        self.tasksController = storyboard?.instantiateViewControllerWithIdentifier("TasksViewController") as! UITableViewController
        self.timesController = storyboard?.instantiateViewControllerWithIdentifier("TimesViewController") as! UITableViewController
        
        self.currentSelection = Selection(clientId: -1, projectId: -1, taskId: -1)
        
        self.clientsController.tableView.delegate = self
//        self.clientsController.tableView.dataSource = self
        
        self.projectsController.tableView.delegate = self
        //        self.projectsController.tableView.dataSource = self
        
        self.tasksController.tableView.delegate = self
        //        self.tasksController.tableView.dataSource = self
        
        self.timesController.tableView.delegate = self
        //        self.timesController.tableView.dataSource = self
        
        // Show the first view.
        self.displayContentController(self.clientsController)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("Selected " + String(indexPath.row))
        if(tableView == self.clientsController.tableView) {
            if(self.currentSelection.clientId < 0) {
                transitionInViewController(lastViewController: self.clientsController, newViewController: self.projectsController)
            }
            
            self.currentSelection.clientId = indexPath.row
        } else if(tableView == self.projectsController.tableView) {
            if(self.currentSelection.projectId < 0) {
                transitionInViewController(lastViewController: self.projectsController, newViewController: self.tasksController)
            }
            
            self.currentSelection.projectId = indexPath.row
        } else if(tableView == self.tasksController.tableView) {
            if(self.currentSelection.taskId < 0) {
                transitionInViewController(lastViewController: self.tasksController, newViewController: self.timesController)
            }
            
            self.currentSelection.taskId = indexPath.row
        } else if(tableView == self.timesController.tableView) {
            // Do nothing.
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayContentController(content: UIViewController!) {
        // Add the new view controller.
        self.addChildViewController(content!)
        // Make sure the view fits perfectly into our layout.
        content!.view.frame = self.visibleFrameForFirstEmbeddedController()
        // Add the new view.
        self.view!.addSubview(content!.view)
        // Tell the child that it now lives at their parents.
        content!.didMoveToParentViewController(self)
    }
    
    func displayContentControllerLater(content: UIViewController!) {
        // Add the new view controller.
        self.addChildViewController(content!)
        // Make sure the view fits perfectly into our layout.
        content!.view.frame = self.visibleFrameForEmbeddededControllers()
        // Add the new view.
        self.view!.addSubview(content!.view)
        // Tell the child that it now lives at their parents.
        content!.didMoveToParentViewController(self)
    }
    
    func visibleFrameForFirstEmbeddedController() -> CGRect {
        let showRect = CGRect(x: 0, y: 0, width: self.view!.frame.width / 2, height:self.view!.frame.height)
        return showRect
    }
    
    func visibleFrameForEmbeddededControllers() -> CGRect {
        let showRect = CGRect(x: self.view!.frame.width / 2, y: 0, width: self.view!.frame.width / 2, height:self.view!.frame.height)
        return showRect
    }
    
    func transitionInViewController(lastViewController prevVC: UIViewController!, newViewController newVC: UIViewController!) {
        self.displayContentControllerLater(newVC)
        if(prevVC.view!.frame.minX > 0) {
          prevVC.view!.frame.offsetInPlace(dx: -prevVC.view.frame.width, dy: 0)
        }
        // Prepare removing from parent.
//        oldVC.willMoveToParentViewController(nil)
        // Add new view controller.
//        self.addChildViewController(newVC!)
//        // Make new view controller transparent.
//        newVC.view.alpha = 0
//        // Make new view controller fit the available space.
//        newVC.view.frame = self.visibleFrameForEmbeddededControllers()
//        // Add the new view.
//        self.view!.addSubview(newVC!.view)
//        // Transition the new view controller to visible and the old one to transparent.
//        self.transitionFromViewController(prevVC, toViewController: newVC, duration: 5.25, options: [], animations: {() -> Void in
//            newVC.view.alpha = 1
//            prevVC.view.alpha = 1
//            if(prevVC.view!.frame.minX > 0) {
//                prevVC.view!.frame.offsetInPlace(dx: -prevVC.view.frame.width, dy: 0)
//            }
//            }, completion: {(finished: Bool) -> Void in
//                // Remove old view controller after animation.
////                prevVC.view.removeFromSuperview()
////                prevVC.removeFromParentViewController()
//                // Make sure new view controller knows they're home.
//                newVC.didMoveToParentViewController(self)
//                // Store current view controller, just in case.
////                self.currentViewController = newVC
//        })

    }
    
}
