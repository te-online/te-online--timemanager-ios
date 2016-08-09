//
//  ViewController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 08.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

class MainViewController: UINavigationController, UIPageViewControllerDataSource {

    var pageViewController: UIPageViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("pageViewController") as? UIPageViewController
        self.pageViewController.dataSource = self
        
        let clientsController = storyboard?.instantiateViewControllerWithIdentifier("ClientsViewController")
        self.pageViewController.setViewControllers([clientsController!], direction: .Forward, animated: true, completion: nil)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return nil
    }

    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 2
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}

