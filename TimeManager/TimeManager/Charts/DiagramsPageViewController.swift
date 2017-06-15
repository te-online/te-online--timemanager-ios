//
//  DiagramsPageViewController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 16.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

protocol DiagramsPageViewControllerDelegate {
    func swipeToPage(_ page: Int)
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
        
        YearChartView = storyboard?.instantiateViewController(withIdentifier: "YearChartView")
        MonthChartView = storyboard?.instantiateViewController(withIdentifier: "MonthChartView")
        WeekChartView = storyboard?.instantiateViewController(withIdentifier: "WeekChartView")
        DayChartView = storyboard?.instantiateViewController(withIdentifier: "DayChartView")
        
        pages.append(YearChartView)
        pages.append(MonthChartView)
        pages.append(WeekChartView)
        pages.append(DayChartView)
        
        setViewControllers([YearChartView], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        var previousIndex = currentIndex - 1
        if currentIndex == 0 {
            previousIndex = pages.count - 1
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        let nextIndex = abs((currentIndex + 1) % pages.count)
        
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        // Find the current view controller after an animation has finished to update the views.
        let viewController = self.viewControllers!.last!
        self.currentPage = pages.index(of: viewController)!
        
        self.refreshDelegate.swipeToPage(self.currentPage)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func jumpTo(_ page: Int) {
        // Jump to a specific page and maintain user's orientation by using the correct slide direction.
        if self.currentPage < page {
            setViewControllers([pages[page]], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        } else if self.currentPage > page {
            setViewControllers([pages[page]], direction: UIPageViewControllerNavigationDirection.reverse, animated: true, completion: nil)
        }
        self.currentPage = page
    }
    
    func reloadData(_ forDate: Date, currentView: Int) {
        // Delegate the reloading when the date has changed.
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

