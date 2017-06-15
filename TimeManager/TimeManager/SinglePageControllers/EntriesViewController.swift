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
        self.clientsController = storyboard?.instantiateViewController(withIdentifier: "ClientsViewController") as! UICollectionViewController
        self.projectsController = storyboard?.instantiateViewController(withIdentifier: "ProjectsViewController") as! UICollectionViewController
        self.tasksController = storyboard?.instantiateViewController(withIdentifier: "TasksViewController") as! UICollectionViewController
        self.timesController = storyboard?.instantiateViewController(withIdentifier: "TimesViewController") as! UICollectionViewController
        
        // Currently there is nothing selected. The view only just did load.
        self.currentSelection = Selection(clientId: "", projectId: "", taskId: "")
        
        (self.clientsController as! CardOfViewDeckController).delegate = self
        (self.projectsController as! CardOfViewDeckController).delegate = self
        (self.tasksController as! CardOfViewDeckController).delegate = self
        (self.timesController as! CardOfViewDeckController).delegate = self
        
        // Get some shadows delivered from the factory.
        self.produceShadow(self.projectsController)
        self.produceShadow(self.tasksController)
        self.produceShadow(self.timesController)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Show the first view.
        self.displayContentController(self.clientsController)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func produceShadow(_ viewController: UIViewController) {
        let shadowPath: UIBezierPath = UIBezierPath()
        shadowPath.move(to: CGPoint(x: 0.0, y: 0.0))
        shadowPath.addLine(to: CGPoint(x: 0.0, y: viewController.view.frame.height))
        shadowPath.addLine(to: CGPoint(x: -2.0, y: viewController.view.frame.height))
        shadowPath.addLine(to: CGPoint(x: -2.0, y: 0.0))
        shadowPath.close()
        
        viewController.view.layer.masksToBounds = false
        viewController.view.layer.shadowColor = UIColor.init(colorLiteralRed: 0.48, green: 0.48, blue: 0.48, alpha: 1.0).cgColor
        viewController.view.layer.shadowRadius = 2
        viewController.view.layer.shadowOpacity = 0.3
        viewController.view.layer.shadowPath = shadowPath.cgPath
    }
    
    func didSelectItemAtIndexPath(_ viewController: UICollectionViewController, indexPath: IndexPath) {
        if(viewController == self.clientsController) {
            // If this is the first selection: Show the projects list.
            if(self.currentSelection.clientId.isEmpty) {
                transitionInViewController(lastViewController: self.clientsController, newViewController: self.projectsController)
            } else {
                // Reset the following views in the hierarchy.
                self.currentSelection.projectId = ""
                self.currentSelection.taskId = ""
                // Clear selection in views, right to this view.
                (self.projectsController as! ProjectsViewController).currentSelection = nil
                (self.tasksController as! TasksViewController).currentSelection = nil
            }
            
            // Show the project's controller.
            (self.projectsController as! CardOfViewDeckController).positionActive()
            self.repositionCards()
            
            // Set the current client.
            let currentClient = (self.clientsController as! ClientsViewController).getCurrentClient()
            (self.projectsController as! ProjectsViewController).setParentClient(currentClient)
            self.currentSelection.clientId = currentClient.uuid
        } else if(viewController == self.projectsController) {
            // If this is the first selection: Show the task's list.
            if(self.currentSelection.projectId.isEmpty) {
                transitionInViewController(lastViewController: self.projectsController, newViewController: self.tasksController)
            } else {
                // Reset the following views in the hierarchy.
                self.currentSelection.taskId = ""
                // Clear selection in views, right to this view.
                (self.tasksController as! TasksViewController).currentSelection = nil
            }
            
            // Show the tasks's controller
            (self.projectsController as! CardOfViewDeckController).positionSideBySideLeft()
            (self.tasksController as! CardOfViewDeckController).positionActive()
            self.repositionCards()
            
            // Set the current project.
            let currentProject = (self.projectsController as! ProjectsViewController).getCurrentProject()
            (self.tasksController as! TasksViewController).setParentProject(currentProject)
            self.currentSelection.projectId = currentProject.uuid
        } else if(viewController == self.tasksController) {
            // If this is the first selection: Show the time's list.
            if(self.currentSelection.taskId.isEmpty) {
                transitionInViewController(lastViewController: self.tasksController, newViewController: self.timesController)
            }
            
            // Show the time's controller.
            (self.tasksController as! CardOfViewDeckController).positionSideBySideLeft()
            (self.timesController as! CardOfViewDeckController).positionActive()
            self.repositionCards()
            
            // Set the current selected task.
            let currentTask = (self.tasksController as! TasksViewController).getCurrentTask()
            (self.timesController as! TimesViewController).setParentTask(currentTask)
            self.currentSelection.taskId = currentTask.uuid
        } else if(viewController == self.timesController) {
            // Do nothing. This is handled by somebody else.
        }
    }
    
    func mightNavigateLeft(_ sender: UICollectionViewController) {
        // Client's list cannot navigate left.
        if(sender == self.clientsController) {
            return
        }
        
        // If one of the views wants to navigate to the left side, let them do so.
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
    
    internal func mightNavigateRight(_ sender: UICollectionViewController) {
        // Time's list cannot navigate right.
        if(sender == self.timesController) {
            return
        }
        
        // If one of the views wants to navigate to the right side, let them do so.
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
    
    // Delegate this task to all child controllers.
    func repositionCards() {
        (self.clientsController as! CardOfViewDeckController).repositionCard()
        (self.projectsController as! CardOfViewDeckController).repositionCard()
        (self.tasksController as! CardOfViewDeckController).repositionCard()
        (self.timesController as! CardOfViewDeckController).repositionCard()
    }
    
    // Move the others sticky with their neighbours. The cards are a bit gooey.
    func mightMoveWithOtherCards(_ sender: UICollectionViewController) {
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
    
    // Reset all selections when the client was deleted.
    func didDeleteClient() {
        self.currentSelection.clientId = ""
        self.currentSelection.projectId = ""
        self.currentSelection.taskId = ""
        (self.clientsController as! ClientsViewController).currentSelection = nil
        (self.projectsController as! ProjectsViewController).currentSelection = nil
        (self.tasksController as! TasksViewController).currentSelection = nil
        
        (self.projectsController as! CardOfViewDeckController).positionInvisible()
        (self.clientsController as! CardOfViewDeckController).positionSideBySideLeft()
        self.repositionCards()
    }
    
    // Reset all selections when the project was deleted.
    func didDeleteProject() {
        self.currentSelection.projectId = ""
        self.currentSelection.taskId = ""
        (self.projectsController as! ProjectsViewController).currentSelection = nil
        (self.tasksController as! TasksViewController).currentSelection = nil
        
        (self.tasksController as! CardOfViewDeckController).positionInvisible()
        (self.projectsController as! CardOfViewDeckController).positionActive()
        self.repositionCards()
    }
    
    // Reset all selections when the task was deleted.
    func didDeleteTask() {
        self.currentSelection.taskId = ""
        (self.tasksController as! TasksViewController).currentSelection = nil
        
        (self.timesController as! CardOfViewDeckController).positionInvisible()
        (self.tasksController as! CardOfViewDeckController).positionActive()
        self.repositionCards()
    }
    
    func displayContentController(_ content: UIViewController!) {
        // Add the new view controller.
        self.addChildViewController(content!)
        // Make sure the view fits perfectly into our layout.
        content!.view.frame = self.visibleFrameForFirstEmbeddedController()
        // Add the new view.
        self.view!.addSubview(content!.view)
        // Tell the child that it now lives at their parents.
        content!.didMove(toParentViewController: self)
    }
    
    func displayContentControllerLater(_ content: UIViewController!) {
        // Add the new view controller.
        self.addChildViewController(content!)
        // Make sure the view fits perfectly into our layout.
        content!.view.frame = self.visibleFrameForEmbeddededControllers()
        // Add the new view.
        self.view!.addSubview(content!.view)
        // Tell the child that it now lives at their parents.
        content!.didMove(toParentViewController: self)
    }
    
    func visibleFrameForFirstEmbeddedController() -> CGRect {
        let showRect = CGRect(x: 0, y: 0, width: self.view!.frame.width / 2, height: self.view!.frame.height)
        return showRect
    }
    
    func visibleFrameForEmbeddededControllers() -> CGRect {
        let showRect = CGRect(x: self.view!.frame.width, y: 0, width: self.view!.frame.width / 2, height: self.view!.frame.height)
        return showRect
    }
    
    // Set the correct position to the view controllers, when transitioning one in.
    func transitionInViewController(lastViewController prevVC: UIViewController!, newViewController newVC: UIViewController!) {
        self.displayContentControllerLater(newVC)
        if(prevVC.view!.frame.minX > 0) {
          prevVC.view!.frame.offsetInPlace(dx: -prevVC.view.frame.width, dy: 0)
        }
    }
    
}
