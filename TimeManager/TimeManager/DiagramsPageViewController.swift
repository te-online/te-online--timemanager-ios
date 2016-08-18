//
//  DiagramsPageViewController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 16.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

class DiagramsPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var pages = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        let page1: UIViewController! = storyboard?.instantiateViewControllerWithIdentifier("YearChartView")
        let page2: UIViewController! = storyboard?.instantiateViewControllerWithIdentifier("MonthChartView")
        let page3: UIViewController! = storyboard?.instantiateViewControllerWithIdentifier("WeekChartView")
        let page4: UIViewController! = storyboard?.instantiateViewControllerWithIdentifier("DayChartView")
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        pages.append(page4)
        
        setViewControllers([page1], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.indexOf(viewController)!
        let previousIndex = abs((currentIndex - 1) % pages.count)
        NSLog("previous " + String(previousIndex))
        if previousIndex == 1 {
            return nil
        }
        return pages[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.indexOf(viewController)!
        let nextIndex = abs((currentIndex + 1) % pages.count)
        return pages[nextIndex]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func jumpTo(page: Int) {
//        if self.currentIndex < page {
            setViewControllers([pages[page]], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
//        } else if self.currentIndex > page {
            setViewControllers([pages[page]], direction: UIPageViewControllerNavigationDirection.Reverse, animated: true, completion: nil)
//        }
    }
    
    func reloadData() {
        // Reload the data here
    }
    
}

