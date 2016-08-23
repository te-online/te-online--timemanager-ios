//
//  DiagramsContainerController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 16.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

class DiagramsContainerController: UIViewController, DiagramsPageViewControllerDelegate {
    
    var currentDate = NSDate()
    var currentPage = 0
    var timeIntervals: [Double] = [365 * 24 * 60 * 60, 30 * 24 * 60 * 60, 7 * 24 * 60 * 60, 24 * 60 * 60]
    
    var tt: TimeTraveller!
    
    var Color = SharedColorPalette.sharedInstance
    
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
        if currentPage == 0 {
            self.currentDate = DateHelper.getDateFor(.PreviousYear, date: self.currentDate)
        } else if currentPage == 1 {
            self.currentDate = DateHelper.getDateFor(.PreviousMonth, date: self.currentDate)
        } else if currentPage == 2 {
            self.currentDate = DateHelper.getDateFor(.PreviousWeek, date: self.currentDate)
        } else if currentPage == 3 {
            self.currentDate = DateHelper.getDateFor(.PreviousDay, date: self.currentDate)
        }
//        self.currentDate = self.currentDate.dateByAddingTimeInterval((-1 * timeIntervals[currentPage]))
        // TODO
        self.reloadData()
    }
    
    @IBAction func NavigateToNextPressed(sender: AnyObject) {
        // Add one week to the current date.
        if currentPage == 0 {
            self.currentDate = DateHelper.getDateFor(.NextYear, date: self.currentDate)
        } else if currentPage == 1 {
            self.currentDate = DateHelper.getDateFor(.NextMonth, date: self.currentDate)
        } else if currentPage == 2 {
            self.currentDate = DateHelper.getDateFor(.NextWeek, date: self.currentDate)
        } else if currentPage == 3 {
            self.currentDate = DateHelper.getDateFor(.NextDay, date: self.currentDate)
        }
        // TODO
        self.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tt = TimeTraveller()
        self.rephraseLabels()
        
        // Load nice background images for highlighted state for our navi buttons
        self.YearNavigationButton.setTitleColor(Color.Blue, forState: .Selected)
        self.MonthNavigationButton.setTitleColor(Color.Blue, forState: .Selected)
        self.WeekNavigationButton.setTitleColor(Color.Blue, forState: .Selected)
        self.DayNavigationButton.setTitleColor(Color.Blue, forState: .Selected)
        
        (self.childViewControllers[0] as! DiagramsPageViewController).refreshDelegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func swipeToPage(page: Int) {
        self.currentPage = page
        self.reloadData()
    }
    
    func reloadData() {
        (self.childViewControllers[0] as! DiagramsPageViewController).reloadData(self.currentDate, currentView: self.currentPage)
        
        self.rephraseLabels()
    }
    
    func rephraseLabels() {
        // Rewrite the total hours and current date position label.
        if currentPage == 0 {
            CurrentNaviPositionLabel.text = String(FormattingHelper.getYearFromDate(self.currentDate))
            TotalCaptionLabel.text = "Year total".uppercaseString
            TotalValueLabel.text = FormattingHelper.formatHoursAsString(tt.getHoursForYearFromDate(self.currentDate))
            
            CurrentNaviPositionLabel.text = String(FormattingHelper.getYearFromDate(self.currentDate))
        } else if currentPage == 1 {
            CurrentNaviPositionLabel.text = FormattingHelper.monthAndYearFromDate(self.currentDate).uppercaseString
            TotalCaptionLabel.text = "Month total".uppercaseString
            TotalValueLabel.text = FormattingHelper.formatHoursAsString(tt.getHoursForMonthFromDate(self.currentDate))
            
            CurrentNaviPositionLabel.text = FormattingHelper.monthAndYearFromDate(self.currentDate).uppercaseString
        } else if currentPage == 2 {
            CurrentNaviPositionLabel.text = FormattingHelper.weekAndYearFromDate(self.currentDate).uppercaseString
            TotalCaptionLabel.text = "Week total".uppercaseString
            TotalValueLabel.text = FormattingHelper.formatHoursAsString(tt.recordedHoursForWeekFromDate(self.currentDate))
            
            CurrentNaviPositionLabel.text = FormattingHelper.weekAndYearFromDate(self.currentDate).uppercaseString
        } else if currentPage == 3 {
            CurrentNaviPositionLabel.text = FormattingHelper.fullDayAndDateFromDate(self.currentDate).uppercaseString
            TotalCaptionLabel.text = "Day total".uppercaseString
            TotalValueLabel.text = FormattingHelper.formatHoursAsString(tt.recordedHoursForDay(self.currentDate))
            
            CurrentNaviPositionLabel.text = FormattingHelper.fullDayAndDateFromDate(self.currentDate).uppercaseString
        }
        
        self.correctButtons()
    }
    
    func correctButtons() {
        if self.currentPage == 0 {
            self.YearNavigationButton.selected = true
            self.MonthNavigationButton.selected = false
            self.WeekNavigationButton.selected = false
            self.DayNavigationButton.selected = false
            NSLog(String(self.YearNavigationButton.selected))
        } else if self.currentPage == 1 {
            self.YearNavigationButton.selected = false
            self.MonthNavigationButton.selected = true
            self.WeekNavigationButton.selected = false
            self.DayNavigationButton.selected = false
        } else if self.currentPage == 2 {
            self.YearNavigationButton.selected = false
            self.MonthNavigationButton.selected = false
            self.WeekNavigationButton.selected = true
            self.DayNavigationButton.selected = false
        } else if self.currentPage == 3 {
            self.YearNavigationButton.selected = false
            self.MonthNavigationButton.selected = false
            self.WeekNavigationButton.selected = false
            self.DayNavigationButton.selected = true
        }
    }
    
}
