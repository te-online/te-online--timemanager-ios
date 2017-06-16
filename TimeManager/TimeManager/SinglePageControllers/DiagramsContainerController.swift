//
//  DiagramsContainerController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 16.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

class DiagramsContainerController: UIViewController, DiagramsPageViewControllerDelegate {
    
    var currentDate = Date()
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
    
    
    @IBAction func YearNavigationButtonPressed(_ sender: AnyObject) {
        (self.childViewControllers[0] as! DiagramsPageViewController).jumpTo(0)
        self.currentPage = 0
        self.rephraseLabels()
    }
    
    @IBAction func MonthNavigationButtonPressed(_ sender: AnyObject) {
        (self.childViewControllers[0] as! DiagramsPageViewController).jumpTo(1)
        self.currentPage = 1
        self.rephraseLabels()
    }
    
    @IBAction func WeekNavigationButtonPressed(_ sender: AnyObject) {
        (self.childViewControllers[0] as! DiagramsPageViewController).jumpTo(2)
        self.currentPage = 2
        self.rephraseLabels()
    }
    
    @IBAction func DayNavigationButtonPressed(_ sender: AnyObject) {
        (self.childViewControllers[0] as! DiagramsPageViewController).jumpTo(3)
        self.currentPage = 3
        self.rephraseLabels()
    }
    
    @IBAction func NavigateToPreviousPressed(_ sender: AnyObject) {
        // Subtract one unit from the current date.
        if currentPage == 0 {
            self.currentDate = DateHelper.getDateFor(.previousYear, date: self.currentDate)
        } else if currentPage == 1 {
            self.currentDate = DateHelper.getDateFor(.previousMonth, date: self.currentDate)
        } else if currentPage == 2 {
            self.currentDate = DateHelper.getDateFor(.previousWeek, date: self.currentDate)
        } else if currentPage == 3 {
            self.currentDate = DateHelper.getDateFor(.previousDay, date: self.currentDate)
        }

        self.reloadData()
    }
    
    @IBAction func NavigateToNextPressed(_ sender: AnyObject) {
        // Add one unit to the current date.
        if currentPage == 0 {
            self.currentDate = DateHelper.getDateFor(.nextYear, date: self.currentDate)
        } else if currentPage == 1 {
            self.currentDate = DateHelper.getDateFor(.nextMonth, date: self.currentDate)
        } else if currentPage == 2 {
            self.currentDate = DateHelper.getDateFor(.nextWeek, date: self.currentDate)
        } else if currentPage == 3 {
            self.currentDate = DateHelper.getDateFor(.nextDay, date: self.currentDate)
        }
        
        self.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tt = TimeTraveller()
        self.rephraseLabels()
        
        // Set nice text colors for highlighted state for our navi buttons.
        self.YearNavigationButton.setTitleColor(Color.Blue, for: .selected)
        self.MonthNavigationButton.setTitleColor(Color.Blue, for: .selected)
        self.WeekNavigationButton.setTitleColor(Color.Blue, for: .selected)
        self.DayNavigationButton.setTitleColor(Color.Blue, for: .selected)
        
        (self.childViewControllers[0] as! DiagramsPageViewController).refreshDelegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func swipeToPage(_ page: Int) {
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
            TotalCaptionLabel.text = "Year total".uppercased()
            TotalValueLabel.text = FormattingHelper.formatHoursAsString(tt.getHoursForYearFromDate(self.currentDate))
            
            CurrentNaviPositionLabel.text = String(FormattingHelper.getYearFromDate(self.currentDate))
        } else if currentPage == 1 {
            TotalCaptionLabel.text = "Month total".uppercased()
            TotalValueLabel.text = FormattingHelper.formatHoursAsString(tt.getHoursForMonthFromDate(self.currentDate))
            
            CurrentNaviPositionLabel.text = FormattingHelper.dateFormat(.monthAndYear, date: self.currentDate).uppercased()
        } else if currentPage == 2 {
            TotalCaptionLabel.text = "Week total".uppercased()
            TotalValueLabel.text = FormattingHelper.formatHoursAsString(tt.recordedHoursForWeekFromDate(self.currentDate))
            
            CurrentNaviPositionLabel.text = FormattingHelper.dateFormat(.weekAndYear, date: self.currentDate).uppercased()
        } else if currentPage == 3 {
            TotalCaptionLabel.text = "Day total".uppercased()
            TotalValueLabel.text = FormattingHelper.formatHoursAsString(tt.recordedHoursForDay(self.currentDate))
            
            CurrentNaviPositionLabel.text = FormattingHelper.dateFormat(.daynameAndDate, date: self.currentDate).uppercased()
        }
        
        self.correctButtons()
    }
    
    func correctButtons() {
        if self.currentPage == 0 {
            self.YearNavigationButton.isSelected = true
            self.MonthNavigationButton.isSelected = false
            self.WeekNavigationButton.isSelected = false
            self.DayNavigationButton.isSelected = false
        } else if self.currentPage == 1 {
            self.YearNavigationButton.isSelected = false
            self.MonthNavigationButton.isSelected = true
            self.WeekNavigationButton.isSelected = false
            self.DayNavigationButton.isSelected = false
        } else if self.currentPage == 2 {
            self.YearNavigationButton.isSelected = false
            self.MonthNavigationButton.isSelected = false
            self.WeekNavigationButton.isSelected = true
            self.DayNavigationButton.isSelected = false
        } else if self.currentPage == 3 {
            self.YearNavigationButton.isSelected = false
            self.MonthNavigationButton.isSelected = false
            self.WeekNavigationButton.isSelected = false
            self.DayNavigationButton.isSelected = true
        }
    }
    
}
