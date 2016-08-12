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
        var clientId: Int!
        var projectId: Int!
        var taskId: Int!
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
        
        self.currentSelection = Selection(clientId: -1, projectId: -1, taskId: -1)
        
        (self.clientsController as! CardOfViewDeckController).delegate = self
        (self.projectsController as! CardOfViewDeckController).delegate = self
        (self.tasksController as! CardOfViewDeckController).delegate = self
        (self.timesController as! CardOfViewDeckController).delegate = self
//        self.clientsController.tableView.dataSource = self
        
//        self.projectsController.collectionView!.delegate = self
        //        self.projectsController.tableView.dataSource = self
        
//        self.tasksController.collectionView!.delegate = self
        //        self.tasksController.tableView.dataSource = self
        
//        self.timesController.collectionView!.delegate = self
        //        self.timesController.tableView.dataSource = self
        
        self.view.layer.masksToBounds = true
        
        // Get some shadows from the factory.
        self.produceShadow(self.projectsController)
        self.produceShadow(self.tasksController)
        self.produceShadow(self.timesController)
        
        // Show the first view.
        self.displayContentController(self.clientsController)
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
//        viewController.view.layer.shadowOffset = CGSizeMake(0, 0)
        viewController.view.layer.shadowRadius = 4
        viewController.view.layer.shadowOpacity = 0.5
        viewController.view.layer.shadowPath = shadowPath.CGPath
    }
    
    func didSelectItemAtIndexPath(viewController: UICollectionViewController, indexPath: NSIndexPath) {
        let collectionView: UICollectionView = viewController.collectionView!
        NSLog("Selected " + String(indexPath.row))
        if(viewController == self.clientsController) {
            if(self.currentSelection.clientId < 0) {
                transitionInViewController(lastViewController: self.clientsController, newViewController: self.projectsController)
            } else {
                self.currentSelection.projectId = -1
                self.currentSelection.taskId = -1
            }
            
            (self.projectsController as! CardOfViewDeckController).positionActive()
            self.repositionCards()
            
            self.currentSelection.clientId = indexPath.row
        } else if(collectionView == self.projectsController.collectionView) {
            if(self.currentSelection.projectId < 0) {
                transitionInViewController(lastViewController: self.projectsController, newViewController: self.tasksController)
            } else {
                self.currentSelection.taskId = -1
            }
            
            (self.projectsController as! CardOfViewDeckController).positionSideBySideLeft()
            (self.tasksController as! CardOfViewDeckController).positionActive()
            self.repositionCards()
            
            self.currentSelection.projectId = indexPath.row
        } else if(collectionView == self.tasksController.collectionView) {
            if(self.currentSelection.taskId < 0) {
                transitionInViewController(lastViewController: self.tasksController, newViewController: self.timesController)
            }
            
            (self.tasksController as! CardOfViewDeckController).positionSideBySideLeft()
            (self.timesController as! CardOfViewDeckController).positionActive()
            self.repositionCards()
            
            self.currentSelection.taskId = indexPath.row
        } else if(collectionView == self.timesController.collectionView) {
            // Do nothing.
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        NSLog("Selected " + String(indexPath.row))
        if(collectionView == self.clientsController.collectionView) {
            if(self.currentSelection.clientId < 0) {
                transitionInViewController(lastViewController: self.clientsController, newViewController: self.projectsController)
            } else {
                self.currentSelection.projectId = -1
                self.currentSelection.taskId = -1
            }
            
            (self.projectsController as! CardOfViewDeckController).positionActive()
            self.repositionCards()
            
            self.currentSelection.clientId = indexPath.row
        } else if(collectionView == self.projectsController.collectionView) {
            if(self.currentSelection.projectId < 0) {
                transitionInViewController(lastViewController: self.projectsController, newViewController: self.tasksController)
            } else {
                self.currentSelection.taskId = -1
            }
            
            (self.projectsController as! CardOfViewDeckController).positionSideBySideLeft()
            (self.tasksController as! CardOfViewDeckController).positionActive()
            self.repositionCards()
            
            self.currentSelection.projectId = indexPath.row
        } else if(collectionView == self.tasksController.collectionView) {
            if(self.currentSelection.taskId < 0) {
                transitionInViewController(lastViewController: self.tasksController, newViewController: self.timesController)
            }
            
            (self.tasksController as! CardOfViewDeckController).positionSideBySideLeft()
            (self.timesController as! CardOfViewDeckController).positionActive()
            self.repositionCards()
            
            self.currentSelection.taskId = indexPath.row
        } else if(collectionView == self.timesController.collectionView) {
            // Do nothing.
        }
    }
    
    func mightNavigateLeft(sender: UICollectionViewController) {
        if(sender == self.clientsController) {
            return
        }
        
        if(sender == self.projectsController && self.currentSelection.projectId >= 0) {
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
//        NSLog("Navigate left")
    }
    
    internal func mightNavigateRight(sender: UICollectionViewController) {
        if(sender == self.timesController) {
            return
        }
        
        if(sender == self.clientsController && self.currentSelection.clientId >= 0) {
//            NSLog("Clients moving")
            (self.clientsController as! CardOfViewDeckController).positionSideBySideLeft()
            (self.projectsController as! CardOfViewDeckController).positionSideBySideRight()
            (self.tasksController as! CardOfViewDeckController).positionInvisible()
            (self.timesController as! CardOfViewDeckController).positionInvisible()
        }
        if(sender == self.projectsController && self.currentSelection.projectId >= 0) {
//            NSLog("Projects moving")
            (self.clientsController as! CardOfViewDeckController).positionInTheDeck()
            (self.projectsController as! CardOfViewDeckController).positionSideBySideLeft()
            (self.tasksController as! CardOfViewDeckController).positionSideBySideRight()
            (self.timesController as! CardOfViewDeckController).positionInvisible()
        }
        if(sender == self.tasksController && self.currentSelection.taskId >= 0) {
//            NSLog("Tasks Moving")
            (self.clientsController as! CardOfViewDeckController).positionInTheDeck()
            (self.projectsController as! CardOfViewDeckController).positionInTheDeck()
            (self.tasksController as! CardOfViewDeckController).positionSideBySideLeft()
            (self.timesController as! CardOfViewDeckController).positionSideBySideRight()
        }
//        NSLog("Navigate right")
    }
    
    func repositionCards() {
        (self.clientsController as! CardOfViewDeckController).repositionCard()
        (self.projectsController as! CardOfViewDeckController).repositionCard()
        (self.tasksController as! CardOfViewDeckController).repositionCard()
        (self.timesController as! CardOfViewDeckController).repositionCard()
    }
    
    func mightMoveWithOtherCards(sender: UICollectionViewController) {
//        NSLog("Might move with left card")
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayContentController(content: UIViewController!) {
        // Add the new view controller.
        self.addChildViewController(content!)
        // Make sure the view fits perfectly into our layout.
        content!.view.frame = self.visibleFrameForFirstEmbeddedController()
//        (content as! UICollectionViewController).collectionView!.collectionViewLayout.invalidateLayout()
        // Add the new view.
        self.view!.addSubview(content!.view)
        // Tell the child that it now lives at their parents.
        content!.didMoveToParentViewController(self)
//        content!.view.clipsToBounds = true
//        (content as! UICollectionViewController).collectionView!.collectionViewLayout.invalidateLayout()
//        (content as! UICollectionViewController).collectionView!.reloadData()
    }
    
    func displayContentControllerLater(content: UIViewController!) {
        // Add the new view controller.
        self.addChildViewController(content!)
        // Make sure the view fits perfectly into our layout.
        content!.view.frame = self.visibleFrameForEmbeddededControllers()
//        (content as! UICollectionViewController).collectionView!.collectionViewLayout.invalidateLayout()
        // Add the new view.
        self.view!.addSubview(content!.view)
        // Tell the child that it now lives at their parents.
        content!.didMoveToParentViewController(self)
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        self.clientsController.collectionView?.collectionViewLayout.invalidateLayout()
//    }
    
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
