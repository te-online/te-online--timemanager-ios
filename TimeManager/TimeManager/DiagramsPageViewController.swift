//
//  DiagramsPageViewController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 16.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

protocol DiagramsPageViewControllerDelegate {
    func swipeToPage(page: Int)
}

class DiagramsPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pages = [UIViewController]()
    var YearChartView: UIViewController!
    var MonthChartView: UIViewController!
    var WeekChartView: UIViewController!
    var DayChartView: UIViewController!
    
    var refreshDelegate: DiagramsPageViewControllerDelegate!
    
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        YearChartView = storyboard?.instantiateViewControllerWithIdentifier("YearChartView")
        MonthChartView = storyboard?.instantiateViewControllerWithIdentifier("MonthChartView")
        WeekChartView = storyboard?.instantiateViewControllerWithIdentifier("WeekChartView")
        DayChartView = storyboard?.instantiateViewControllerWithIdentifier("DayChartView")
        
        pages.append(YearChartView)
        pages.append(MonthChartView)
        pages.append(WeekChartView)
        pages.append(DayChartView)
        
        setViewControllers([YearChartView], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.indexOf(viewController)!
        var previousIndex = currentIndex - 1
        if currentIndex == 0 {
            previousIndex = pages.count - 1
        }
        
        self.currentPage = previousIndex
        return pages[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.indexOf(viewController)!
        let nextIndex = abs((currentIndex + 1) % pages.count)
        
        self.currentPage = nextIndex
        return pages[nextIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        NSLog("swipe to %@", String(self.currentPage))
        self.refreshDelegate.swipeToPage(self.currentPage)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func jumpTo(page: Int) {
        if self.currentPage < page {
            setViewControllers([pages[page]], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        } else if self.currentPage > page {
            setViewControllers([pages[page]], direction: UIPageViewControllerNavigationDirection.Reverse, animated: true, completion: nil)
        }
        self.currentPage = page
    }
    
    func reloadData(forDate: NSDate, currentView: Int) {
        // Reload the data here.
        if currentView == 0 {
            (YearChartView as! YearChartViewController).reloadData(forDate)
        } else if currentView == 1 {
            (MonthChartView as! MonthChartViewController).reloadData(forDate)
        } else if currentView == 2 {
            (WeekChartView as! WeekChartViewController).reloadData(forDate)
        } else if currentView == 3 {
            (DayChartView as! DayChartViewController).reloadData(forDate)
        }
    }
    
}

