//
//  ContainerViewController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 09.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    var clientsController: UIViewController!
    var overviewScreenController: UIViewController!
    var statisticsScreenController: UIViewController!
    var currentViewController: UIViewController!
    
//    var currentScreen = Int()
//    var screens = [String]()
    @IBAction func NavBarButtonStatisticsTouched(sender: AnyObject) {
        self.hideContentController(self.currentViewController)
        self.displayContentController(self.statisticsScreenController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        currentScreen = 0;
//        screens = ["OverviewScreenContainer", "EntriesScreenContainer", "StatisticsScreenContainer"]
        self.clientsController = storyboard?.instantiateViewControllerWithIdentifier("ClientsViewController")
        self.overviewScreenController = storyboard?.instantiateViewControllerWithIdentifier("OverviewScreenController")
        self.statisticsScreenController = storyboard?.instantiateViewControllerWithIdentifier("StatisticsScreenController")
        self.currentViewController = nil
        
        self.displayContentController(overviewScreenController!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayContentController(content: UIViewController!) {
        if(content == nil) {
            return
        }
        self.addChildViewController(content!)
        content!.view.frame = self.frameFromContentController()
        self.view!.addSubview(content!.view)
        content!.didMoveToParentViewController(self)
        self.currentViewController = content
    }
    
    func frameFromContentController() -> CGRect {
        let showRect = CGRect(x: 86, y: 0, width: self.view!.frame.width - 86, height:self.view!.frame.height)
        return showRect
    }
    
    func hideContentController(content: UIViewController) {
        content.willMoveToParentViewController(nil)
        content.view.removeFromSuperview()
        content.removeFromParentViewController()
    }
    
//    func cycleFromViewController(oldVC: UIViewController, toViewController newVC: UIViewController) {
//        oldVC.willMoveToParentViewController(nil)
//        self.addChildViewController(newVC)
//        newVC.view.frame = self.newViewStartFrame()
//        var endFrame: CGRect = self.oldViewEndFrame()
//        self.transitionFromViewController(oldVC, toViewController: newVC, duration: 0.25, options: [], animations: {() -> Void in
//            newVC.view.frame = oldVC.view.frame
//            oldVC.view.frame = endFrame
//            }, completion: {(finished: Bool) -> Void in
//                oldVC.removeFromParentViewController()
//                newVC.didMoveToParentViewController(self)
//        })
//    }
    
}