//
//  ContainerViewController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 09.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    var entriesScreenController: UIViewController!
    var overviewScreenController: UIViewController!
    var statisticsScreenController: UIViewController!
    var currentViewController: UIViewController!
    
    @IBOutlet weak var SyncingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var SyncingText: UILabel!
    
    @IBOutlet weak var OverviewButton: UIButton!
    @IBOutlet weak var EntriesButton: UIButton!
    @IBOutlet weak var StatisticsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideSyncInProgress()
        
        // Load nice background images for highlighted state for our navi buttons
        self.OverviewButton.setBackgroundImage(UIImage(named: "overview-icon-active.png"), forState: .Selected)
        self.EntriesButton.setBackgroundImage(UIImage(named: "entries-icon-active.png"), forState: .Selected)
        self.StatisticsButton.setBackgroundImage(UIImage(named: "statistics-icon-active.png"), forState: .Selected)
        
        // Load all the nice child views we're going to use.
        self.entriesScreenController = storyboard?.instantiateViewControllerWithIdentifier("EntriesViewController")
        self.overviewScreenController = storyboard?.instantiateViewControllerWithIdentifier("OverviewScreenController")
        self.statisticsScreenController = storyboard?.instantiateViewControllerWithIdentifier("StatisticsScreenController")
        self.currentViewController = nil
        
        // Show the first view.
        self.displayContentController(overviewScreenController!)
        
        self.correctButtons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissSettings(unwindSegue: UIStoryboardSegue) {
        // We might want to save the settings at some point here.
        // Or just get rid of the modal window.
        
    }
    
    @IBAction func NavBarButtonOverviewTouched(sender: AnyObject) {
        self.cycleFromViewController(fromViewController: self.currentViewController, toViewController: self.overviewScreenController)
    }
    
    @IBAction func NavBarButtonEntriesTouched(sender: AnyObject) {
        self.cycleFromViewController(fromViewController: self.currentViewController, toViewController: self.entriesScreenController)
    }
    
    @IBAction func NavBarButtonStatisticsTouched(sender: AnyObject) {
        self.cycleFromViewController(fromViewController: self.currentViewController, toViewController: self.statisticsScreenController)
    }
    
    func displayContentController(content: UIViewController!) {
        // Add the new view controller.
        self.addChildViewController(content!)
        // Make sure the view fits perfectly into our layout.
        content!.view.frame = self.visibleFrameForEmbeddedControllers()
        // Add the new view.
        self.view!.addSubview(content!.view)
        // Tell the child that it now lives at their parents.
        content!.didMoveToParentViewController(self)
        // Store the current view controller, just in case.
        self.currentViewController = content
    }
    
    func visibleFrameForEmbeddedControllers() -> CGRect {
        // Let's give them a rect, where the nav bar is still visible (Nav Bar is 86px in width and full height).
        let showRect = CGRect(x: 86, y: 0, width: self.view!.frame.width - 86, height:self.view!.frame.height)
        return showRect
    }
    
    func cycleFromViewController(fromViewController oldVC: UIViewController!, toViewController newVC: UIViewController!) {
        if(oldVC == newVC || oldVC == nil || newVC == nil) {
            return
        }
        // Prepare removing from parent.
        oldVC.willMoveToParentViewController(nil)
        // Add new view controller.
        self.addChildViewController(newVC!)
        // Make new view controller transparent.
        newVC.view.alpha = 0
        // Make new view controller fit the available space.
        newVC.view.frame = self.visibleFrameForEmbeddedControllers()
        // Add the new view.
        self.view!.addSubview(newVC!.view)
        // Transition the new view controller to visible and the old one to transparent.
        self.transitionFromViewController(oldVC, toViewController: newVC, duration: 0.25, options: [], animations: {() -> Void in
            newVC.view.alpha = 1
            oldVC.view.alpha = 0
            }, completion: {(finished: Bool) -> Void in
                // Remove old view controller after animation.
                oldVC.view.removeFromSuperview()
                oldVC.removeFromParentViewController()
                // Make sure new view controller knows they're home.
                newVC.didMoveToParentViewController(self)
                // Store current view controller, just in case.
                self.currentViewController = newVC
                self.correctButtons()
        })
    }
    
    func correctButtons() {
        if self.currentViewController == self.overviewScreenController {
            self.OverviewButton.selected = true
            self.EntriesButton.selected = false
            self.StatisticsButton.selected = false
        }
        if self.currentViewController == self.entriesScreenController {
            self.OverviewButton.selected = false
            self.EntriesButton.selected = true
            self.StatisticsButton.selected = false
        }
        if self.currentViewController == self.statisticsScreenController {
            self.OverviewButton.selected = false
            self.EntriesButton.selected = false
            self.StatisticsButton.selected = true
        }
    }
    
    func showSyncInProgress() {
        if SyncingSpinner != nil && SyncingText != nil {
            SyncingSpinner.alpha = 1
            SyncingText.alpha = 1
        }
        
    }
    
    func hideSyncInProgress() {
        if SyncingSpinner != nil && SyncingText != nil {
            SyncingSpinner.alpha = 0
            SyncingText.alpha = 0
        }
    }
    
}