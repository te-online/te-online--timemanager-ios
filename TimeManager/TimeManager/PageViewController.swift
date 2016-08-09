//
//  ViewController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 08.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    let viewControllerIdentifiers = ["ClientsViewController", "ProjectsViewController"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let clientsController = storyboard?.instantiateViewControllerWithIdentifier(viewControllerIdentifiers[0])
        let projectsController = storyboard?.instantiateViewControllerWithIdentifier(viewControllerIdentifiers[1])
        
        let direction = UIPageViewControllerNavigationDirection(rawValue: 2)
        self.setViewControllers([clientsController!, projectsController!], direction: direction!, animated: true, completion: nil)
        
//        let projectsController = storyboard?.instantiateViewControllerWithIdentifier(viewControllerIdentifiers[1])
        
//        addChildViewController(clientsController!)
//        addChildViewController(projectsController!)
        
        //        self.presentViewController(clientsController!, animated: true, completion: nil)
        //        self.presentViewController(projectsController!, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

