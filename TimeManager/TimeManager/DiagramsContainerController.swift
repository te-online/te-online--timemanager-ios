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
    
    var tt: TimeTraveller!
    
    @IBOutlet weak var PageViewContainer: UIView!
    @IBOutlet weak var YearNavigationButton: UIButton!
    @IBOutlet weak var MonthNavigationButton: UIButton!
    @IBOutlet weak var WeekNavigationButton: UIButton!
    @IBOutlet weak var DayNavigationButton: UIButton!
    @IBOutlet weak var CurrentNaviPositionLabel: UILabel!
    @IBOutlet weak var TotalCaptionLabel: UILabel!
    @IBOutlet weak var TotalValueLabel: UILabel!
    
    
    @IBAction func YearNavigationButtonPressed(sender: AnyObject) {
        (self.childViewControllers[0] as! DiagramsPageViewController).jumpTo(0)
        self.currentPage = 0
        self.rephraseLabels()
    }
    
    @IBAction func MonthNavigationButtonPressed(sender: AnyObject) {
        (self.childViewControllers[0] as! DiagramsPageViewController).jumpTo(1)
        self.currentPage = 1
        self.rephraseLabels()
    }
    
    @IBAction func WeekNavigationButtonPressed(sender: AnyObject) {
        (self.childViewControllers[0] as! DiagramsPageViewController).jumpTo(2)
        self.currentPage = 2
        self.rephraseLabels()
    }
    
    @IBAction func DayNavigationButtonPressed(sender: AnyObject) {
        (self.childViewControllers[0] as! DiagramsPageViewController).jumpTo(3)
        self.currentPage = 3
        self.rephraseLabels()
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
        
        tt = TimeTraveller()
        self.rephraseLabels()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadData() {
        (self.childViewControllers[0] as! DiagramsPageViewController).reloadData()
    }
    
    func rephraseLabels() {
        if currentPage == 0 {
            CurrentNaviPositionLabel.text = String(FormattingHelper.getYearFromDate(self.currentDate))
            TotalCaptionLabel.text = "Year total".uppercaseString
            TotalValueLabel.text = FormattingHelper.formatHoursAsString(tt.getHoursForYearFromDate(self.currentDate))
        }
        if currentPage == 1 {
            CurrentNaviPositionLabel.text = FormattingHelper.monthAndYearFromDate(self.currentDate).uppercaseString
            TotalCaptionLabel.text = "Month total".uppercaseString
            TotalValueLabel.text = FormattingHelper.formatHoursAsString(tt.getHoursForMonthFromDate(self.currentDate))
        }
        if currentPage == 2 {
            CurrentNaviPositionLabel.text = FormattingHelper.weekAndYearFromDate(self.currentDate).uppercaseString
            TotalCaptionLabel.text = "Week total".uppercaseString
            TotalValueLabel.text = FormattingHelper.formatHoursAsString(tt.recordedHoursForWeekFromDate(self.currentDate))
        }
        if currentPage == 3 {
            CurrentNaviPositionLabel.text = FormattingHelper.fullDayAndDateFromDate(self.currentDate).uppercaseString
            TotalCaptionLabel.text = "Day total".uppercaseString
            TotalValueLabel.text = FormattingHelper.formatHoursAsString(tt.getHoursForYearFromDate(self.currentDate))
            TotalValueLabel.text = FormattingHelper.formatHoursAsString(tt.recordedHoursForDay(self.currentDate))
        }
    }
    
}
