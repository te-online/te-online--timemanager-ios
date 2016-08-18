//
//  DiagramsContainerController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 16.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

class DiagramsContainerController: UIViewController {
    
    var currentDate = NSDate()
    var currentPage = 0
    var timeIntervals: [Double] = [365 * 24 * 60 * 60, 30 * 24 * 60 * 60, 7 * 24 * 60 * 60, 24 * 60 * 60]
    
    @IBOutlet weak var PageViewContainer: UIView!
    @IBOutlet weak var YearNavigationButton: UIButton!
    @IBOutlet weak var MonthNavigationButton: UIButton!
    @IBOutlet weak var WeekNavigationButton: UIButton!
    @IBOutlet weak var DayNavigationButton: UIButton!
    @IBOutlet weak var CurrentNaviPositionLabel: UILabel!
    
    @IBAction func YearNavigationButtonPressed(sender: AnyObject) {
        (self.childViewControllers[0] as! DiagramsPageViewController).jumpTo(0)
        self.currentPage = 0
    }
    
    @IBAction func MonthNavigationButtonPressed(sender: AnyObject) {
        (self.childViewControllers[0] as! DiagramsPageViewController).jumpTo(1)
        self.currentPage = 1
    }
    
    @IBAction func WeekNavigationButtonPressed(sender: AnyObject) {
        (self.childViewControllers[0] as! DiagramsPageViewController).jumpTo(2)
        self.currentPage = 2
    }
    
    @IBAction func DayNavigationButtonPressed(sender: AnyObject) {
        (self.childViewControllers[0] as! DiagramsPageViewController).jumpTo(3)
        self.currentPage = 3
    }
    
    @IBAction func NavigateToPreviousPressed(sender: AnyObject) {
        // Subtract one week from the current date.
        self.currentDate = self.currentDate.dateByAddingTimeInterval((-1 * timeIntervals[currentPage]))
        self.reloadData()
    }
    
    @IBAction func NavigateToNextPressed(sender: AnyObject) {
        // Add one week to the current date.
        self.currentDate = self.currentDate.dateByAddingTimeInterval((timeIntervals[currentPage]))
        self.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadData() {
        (self.childViewControllers[0] as! DiagramsPageViewController).reloadData()
    }
    
}
