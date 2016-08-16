//
//  EntriesViewController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 09.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

class EntriesViewController: UIViewController, UICollectionViewDelegate, CardOfViewDeckControllerDelegate {
    
    struct Selection {
        var clientId: String!
        var projectId: String!
        var taskId: String!
    }
    
    var currentSelection: Selection!
    
    var clientsController: UICollectionViewController!
    var projectsController: UICollectionViewController!
    var tasksController: UICollectionViewController!
    var timesController: UICollectionViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load all the nice child views we're going to use.
        self.clientsController = storyboard?.instantiateViewControllerWithIdentifier("ClientsViewController") as! UICollectionViewController
        self.projectsController = storyboard?.instantiateViewControllerWithIdentifier("ProjectsViewController") as! UICollectionViewController
        self.tasksController = storyboard?.instantiateViewControllerWithIdentifier("TasksViewController") as! UICollectionViewController
        self.timesController = storyboard?.instantiateViewControllerWithIdentifier("TimesViewController") as! UICollectionViewController
        
        self.currentSelection = Selection(clientId: "", projectId: "", taskId: "")
        
        (self.clientsController as! CardOfViewDeckController).delegate = self
        (self.projectsController as! CardOfViewDeckController).delegate = self
        (self.tasksController as! CardOfViewDeckController).delegate = self
        (self.timesController as! CardOfViewDeckController).delegate = self
        
        self.view.layer.masksToBounds = true
        
        // Get some shadows from the factory.
        self.produceShadow(self.projectsController)
        self.produceShadow(self.tasksController)
        self.produceShadow(self.timesController)
        
        // Show the first view.
        self.displayContentController(self.clientsController)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func produceShadow(viewController: UIViewController) {
        let shadowPath: UIBezierPath = UIBezierPath()
        shadowPath.moveToPoint(CGPointMake(0.0, 0.0))
        shadowPath.addLineToPoint(CGPointMake(0.0, CGRectGetHeight(viewController.view.frame)))
        shadowPath.addLineToPoint(CGPointMake(-4.0, CGRectGetHeight(viewController.view.frame)))
        shadowPath.addLineToPoint(CGPointMake(-4.0, 0.0))
        shadowPath.closePath()
        
        viewController.view.layer.masksToBounds = false
        viewController.view.layer.shadowColor = UIColor.init(colorLiteralRed: 0.48, green: 0.48, blue: 0.48, alpha: 1.0).CGColor
        viewController.view.layer.shadowRadius = 4
        viewController.view.layer.shadowOpacity = 0.5
        viewController.view.layer.shadowPath = shadowPath.CGPath
    }
    
    func didSelectItemAtIndexPath(viewController: UICollectionViewController, indexPath: NSIndexPath) {
        if(viewController == self.clientsController) {
            if(self.currentSelection.clientId.isEmpty) {
                transitionInViewController(lastViewController: self.clientsController, newViewController: self.projectsController)
            } else {
                self.currentSelection.projectId = ""
                self.currentSelection.taskId = ""
            }
            
            (self.projectsController as! CardOfViewDeckController).positionActive()
            self.repositionCards()

            let currentClient = (self.clientsController as! ClientsViewController).getCurrentClient()
            (self.projectsController as! ProjectsViewController).setParentClient(currentClient)
            self.currentSelection.clientId = currentClient.uuid
        } else if(viewController == self.projectsController) {
            if(self.currentSelection.projectId.isEmpty) {
                transitionInViewController(lastViewController: self.projectsController, newViewController: self.tasksController)
            } else {
                self.currentSelection.taskId = ""
            }
            
            (self.projectsController as! CardOfViewDeckController).positionSideBySideLeft()
            (self.tasksController as! CardOfViewDeckController).positionActive()
            self.repositionCards()
            
            let currentProject = (self.projectsController as! ProjectsViewController).getCurrentProject()
            (self.tasksController as! TasksViewController).setParentProject(currentProject)
            self.currentSelection.projectId = currentProject.uuid
        } else if(viewController == self.tasksController) {
            if(self.currentSelection.taskId.isEmpty) {
                transitionInViewController(lastViewController: self.tasksController, newViewController: self.timesController)
            }
            
            (self.tasksController as! CardOfViewDeckController).positionSideBySideLeft()
            (self.timesController as! CardOfViewDeckController).positionActive()
            self.repositionCards()
            
//            let currentTask = (self.tasksController as! TasksViewController).getCurrentTask()
//            (self.timesController as! TimesViewController).setParentProject(currentTask)
//            self.currentSelection.taskId = currentTask.uuid
        } else if(viewController == self.timesController) {
            // Do nothing.
        }
    }
    
    func mightNavigateLeft(sender: UICollectionViewController) {
        if(sender == self.clientsController) {
            return
        }
        
        if(sender == self.projectsController && !self.currentSelection.projectId.isEmpty) {
            (self.clientsController as! CardOfViewDeckController).positionSideBySideLeft()
            (self.projectsController as! CardOfViewDeckController).positionSideBySideRight()
            (self.tasksController as! CardOfViewDeckController).positionInvisible()
            (self.timesController as! CardOfViewDeckController).positionInvisible()
        }
        if(sender == self.tasksController) {
            (self.clientsController as! CardOfViewDeckController).positionSideBySideLeft()
            (self.projectsController as! CardOfViewDeckController).positionSideBySideRight()
            (self.tasksController as! CardOfViewDeckController).positionInvisible()
            (self.timesController as! CardOfViewDeckController).positionInvisible()
        }
        if(sender == self.timesController) {
            (self.clientsController as! CardOfViewDeckController).positionInTheDeck()
            (self.projectsController as! CardOfViewDeckController).positionSideBySideLeft()
            (self.tasksController as! CardOfViewDeckController).positionSideBySideRight()
            (self.timesController as! CardOfViewDeckController).positionInvisible()
        }
    }
    
    internal func mightNavigateRight(sender: UICollectionViewController) {
        if(sender == self.timesController) {
            return
        }
        
        if(sender == self.clientsController && !self.currentSelection.clientId.isEmpty) {
            (self.clientsController as! CardOfViewDeckController).positionSideBySideLeft()
            (self.projectsController as! CardOfViewDeckController).positionSideBySideRight()
            (self.tasksController as! CardOfViewDeckController).positionInvisible()
            (self.timesController as! CardOfViewDeckController).positionInvisible()
        }
        if(sender == self.projectsController && !self.currentSelection.projectId.isEmpty) {
            (self.clientsController as! CardOfViewDeckController).positionInTheDeck()
            (self.projectsController as! CardOfViewDeckController).positionSideBySideLeft()
            (self.tasksController as! CardOfViewDeckController).positionSideBySideRight()
            (self.timesController as! CardOfViewDeckController).positionInvisible()
        }
        if(sender == self.tasksController && !self.currentSelection.taskId.isEmpty) {
            (self.clientsController as! CardOfViewDeckController).positionInTheDeck()
            (self.projectsController as! CardOfViewDeckController).positionInTheDeck()
            (self.tasksController as! CardOfViewDeckController).positionSideBySideLeft()
            (self.timesController as! CardOfViewDeckController).positionSideBySideRight()
        }
    }
    
    func repositionCards() {
        (self.clientsController as! CardOfViewDeckController).repositionCard()
        (self.projectsController as! CardOfViewDeckController).repositionCard()
        (self.tasksController as! CardOfViewDeckController).repositionCard()
        (self.timesController as! CardOfViewDeckController).repositionCard()
    }
    
    func mightMoveWithOtherCards(sender: UICollectionViewController) {
        if(sender == self.clientsController) {
            (self.projectsController as! CardOfViewDeckController).moveCardRightHandWithOtherCardsCenterPosition((self.clientsController as! CardOfViewDeckController).getX())
        }
        if(sender == self.projectsController) {
            (self.tasksController as! CardOfViewDeckController).moveCardRightHandWithOtherCardsCenterPosition((self.projectsController as! CardOfViewDeckController).getX())
            (self.clientsController as! CardOfViewDeckController).moveCardLeftHandWithOtherCardsCenterPosition((self.projectsController as! CardOfViewDeckController).getX())
        }
        if(sender == self.tasksController) {
            (self.timesController as! CardOfViewDeckController).moveCardRightHandWithOtherCardsCenterPosition((self.tasksController as! CardOfViewDeckController).getX())
            (self.projectsController as! CardOfViewDeckController).moveCardLeftHandWithOtherCardsCenterPosition((self.tasksController as! CardOfViewDeckController).getX())
        }
        if(sender == self.timesController) {
            (self.tasksController as! CardOfViewDeckController).moveCardLeftHandWithOtherCardsCenterPosition((self.timesController as! CardOfViewDeckController).getX())
        }

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
        let showRect = CGRect(x: 0, y: 0, width: self.view!.frame.width / 2, height: self.view!.frame.height)
        return showRect
    }
    
    func visibleFrameForEmbeddededControllers() -> CGRect {
        let showRect = CGRect(x: self.view!.frame.width /*/ 2*/, y: 0, width: self.view!.frame.width / 2, height: self.view!.frame.height)
        return showRect
    }
    
    func transitionInViewController(lastViewController prevVC: UIViewController!, newViewController newVC: UIViewController!) {
        self.displayContentControllerLater(newVC)
        if(prevVC.view!.frame.minX > 0) {
          prevVC.view!.frame.offsetInPlace(dx: -prevVC.view.frame.width, dy: 0)
        }
    }
    
}
