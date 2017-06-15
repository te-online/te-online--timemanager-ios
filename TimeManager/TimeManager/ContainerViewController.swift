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
    @IBOutlet weak var NaviView: UIView!
    
    @IBOutlet weak var OverviewButton: UIButton!
    @IBOutlet weak var EntriesButton: UIButton!
    @IBOutlet weak var StatisticsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide the sync progress, visible due to storyboard.
        self.hideSyncInProgress()
        
        // Load nice background images for highlighted state for our navi buttons.
        self.OverviewButton.setBackgroundImage(UIImage(named: "overview-icon-active.png"), for: .selected)
        self.EntriesButton.setBackgroundImage(UIImage(named: "entries-icon-active.png"), for: .selected)
        self.StatisticsButton.setBackgroundImage(UIImage(named: "statistics-icon-active.png"), for: .selected)
        
        // Load all the nice child views we're going to use.
        self.entriesScreenController = storyboard?.instantiateViewController(withIdentifier: "EntriesViewController")
        self.overviewScreenController = storyboard?.instantiateViewController(withIdentifier: "OverviewScreenController")
        self.statisticsScreenController = storyboard?.instantiateViewController(withIdentifier: "StatisticsScreenController")
        self.currentViewController = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Show the first subview, once this view fully appeared.
        self.displayContentController(overviewScreenController!)
        // Set the correct state for the navi buttons.
        self.correctButtons()
        
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissSettings(_ unwindSegue: UIStoryboardSegue) {
        // Just get rid of the modal window.
        
    }
    
    @IBAction func NavBarButtonOverviewTouched(_ sender: AnyObject) {
        self.cycleFromViewController(fromViewController: self.currentViewController, toViewController: self.overviewScreenController)
    }
    
    @IBAction func NavBarButtonEntriesTouched(_ sender: AnyObject) {
        self.cycleFromViewController(fromViewController: self.currentViewController, toViewController: self.entriesScreenController)
    }
    
    @IBAction func NavBarButtonStatisticsTouched(_ sender: AnyObject) {
        self.cycleFromViewController(fromViewController: self.currentViewController, toViewController: self.statisticsScreenController)
    }
    
    func displayContentController(_ content: UIViewController!) {
        // Add the new view controller.
        self.addChildViewController(content!)
        // Make sure the view fits perfectly into our layout.
        content!.view.frame = self.visibleFrameForEmbeddedControllers()
        // Add the new view.
        self.view!.addSubview(content!.view)
        // Tell the child that it now lives at their parents.
        content!.didMove(toParentViewController: self)
        // Store the current view controller, just in case.
        self.currentViewController = content
    }
    
    func visibleFrameForEmbeddedControllers() -> CGRect {
        // Let's give them a rect, where the nav bar is still visible (Nav Bar is 86px in width and full height).
        let showRect = CGRect(x: 86, y: 0, width: self.view!.frame.width - 86, height:self.view!.frame.height)
        return showRect
    }
    
    // see also http://stackoverflow.com/questions/22676938/unbalanced-calls-to-begin-end-appearance-transitions-for-uiviewcontroller
    func cycleFromViewController(fromViewController oldVC: UIViewController!, toViewController newVC: UIViewController!) {
        if(oldVC == newVC || oldVC == nil || newVC == nil) {
            return
        }
        // Prepare removing from parent.
        oldVC.willMove(toParentViewController: nil)
        // Add new view controller.
        self.addChildViewController(newVC!)
        // Make new view controller fit the available space.
        newVC.view.frame = self.visibleFrameForEmbeddedControllers()
        // Make new view controller transparent.
        newVC.view.alpha = 0
        // Transition the new view controller to visible and the old one to transparent.
        self.transition(from: oldVC, to: newVC, duration: 0.25, options: [], animations: {() -> Void in
            newVC.view.alpha = 1
            oldVC.view.alpha = 0
            }, completion: {(finished: Bool) -> Void in
                // Remove old view controller after animation.
                oldVC.removeFromParentViewController()
                // Make sure new view controller knows they're home.
                newVC.didMove(toParentViewController: self)
                // Send the new view to the back.
                self.view!.bringSubview(toFront: self.NaviView)
                // Store current view controller, just in case.
                self.currentViewController = newVC
                // Correct the navi buttons appearance.
                self.correctButtons()
            }
        )
    }
    
    func correctButtons() {
        // Set the selected navi button based on the current view controller.
        if self.currentViewController == self.overviewScreenController {
            self.OverviewButton.isSelected = true
            self.EntriesButton.isSelected = false
            self.StatisticsButton.isSelected = false
        }
        if self.currentViewController == self.entriesScreenController {
            self.OverviewButton.isSelected = false
            self.EntriesButton.isSelected = true
            self.StatisticsButton.isSelected = false
        }
        if self.currentViewController == self.statisticsScreenController {
            self.OverviewButton.isSelected = false
            self.EntriesButton.isSelected = false
            self.StatisticsButton.isSelected = true
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
