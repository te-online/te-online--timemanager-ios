//
//  OverviewController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 09.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

class OverviewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    struct RecentTask {
        var clientName: String!
        var projectName: String!
        var taskName: String!
        var dayValues: [String]!
    }
    
    var tasks = [RecentTask]()
    var days = [String]()
    var currentDate = NSDate()
    
    var weekTotal: Int!

    @IBOutlet weak var TodaysHoursMainLabel: UILabel!
    @IBOutlet weak var WeeksHoursMainLabel: UILabel!
    @IBOutlet weak var WeeksHoursTableLabel: UILabel!
    
    @IBOutlet weak var CurrentWeekLabel: UILabel!
    
    @IBOutlet weak var TasksCollectionView: UICollectionView!
    @IBOutlet weak var HoursCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TasksCollectionView.delegate = self
        TasksCollectionView.dataSource = self
        
        HoursCollectionView.delegate = self
        HoursCollectionView.dataSource = self
        
        self.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.loadData()
        super.viewWillAppear(animated)
    }

    @IBAction func NavigateToPreviousWeekButtonPressed(sender: AnyObject) {
        // Subtract one week from the current date.
        self.currentDate = self.currentDate.dateByAddingTimeInterval((-1 * 7 * 24 * 60 * 60))
        self.loadData()
    }
    
    @IBAction func NavigateToNextWeekButtonPressed(sender: AnyObject) {
        // Add one week to the current date.
        self.currentDate = self.currentDate.dateByAddingTimeInterval((7 * 24 * 60 * 60))
        // If currentdate variable is greater or equal to today, don't let them go into the future.
        if (self.currentDate.compare(NSDate()) == NSComparisonResult.OrderedDescending || self.currentDate.compare(NSDate()) == NSComparisonResult.OrderedSame) {
            (sender as! UIButton).enabled = false
        } else {
            (sender as! UIButton).enabled = true
        }
        self.loadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == TasksCollectionView) {
            return self.tasks.count
        } else if(collectionView == HoursCollectionView) {
            return 35
        }
        
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if(collectionView == TasksCollectionView) {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("taskCell", forIndexPath: indexPath) as UICollectionViewCell
            
            let ProjectNameLabel = cell.viewWithTag(1) as! UILabel
            ProjectNameLabel.text = self.tasks[indexPath.row].projectName
            
            let TaskNameLabel = cell.viewWithTag(2) as! UILabel
            TaskNameLabel.text = "> " + self.tasks[indexPath.row].taskName
            
            let ClientNameLabel = cell.viewWithTag(3) as! UILabel
            ClientNameLabel.text = self.tasks[indexPath.row].clientName
            
            return cell
        } else if(collectionView == HoursCollectionView) {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("hourCell", forIndexPath: indexPath) as UICollectionViewCell

            let row = Int(floor(Double(indexPath.row) / 7))
            let column = Int(Double(indexPath.row) - Double(7 * row))
            
            let HourValueLabel = cell.viewWithTag(1) as! UILabel
            
            if row < self.tasks.count {
                HourValueLabel.text = self.tasks[row].dayValues[column]
            } else {
                HourValueLabel.text = ""
            }
            
            return cell
        }
        
        return collectionView.dequeueReusableCellWithReuseIdentifier("", forIndexPath: indexPath) as UICollectionViewCell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        var reusableView: UICollectionReusableView!
        reusableView = nil
        
        if(kind == UICollectionElementKindSectionHeader) {
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "hoursDayLegend", forIndexPath: indexPath)
            
            for i in 1...7 {
                let Label = headerView.viewWithTag(i) as! UILabel
                Label.text = self.days[i-1]
            }
            
            reusableView = headerView
        }
        
        return reusableView
    }
    
    func loadData() {
        let tt = TimeTraveller()
        let today = tt.todaysRecordedHours()
        let thisWeek = tt.thisWeeksRecordedHours()
        let week = tt.recordedHoursForWeekFromDate(self.currentDate)
        let days = tt.daysOfWeekFromDate(self.currentDate)
        let entries = tt.fiveMostRecentTasksInWeekByDate(self.currentDate)
        
        var newTasks = [RecentTask]()
        for entry in entries {
            let task = (entry as TaskObject)
            let project = task.project
            let client = project?.client
            let newTask = RecentTask(
                clientName: client!.name,
                projectName: project!.name,
                taskName: task.name,
                dayValues: tt.recordedHoursForWeekInTaskFromDate(currentDate, task: (entry as TaskObject))
            )
            newTasks.append(newTask)
        }
        
        self.tasks = newTasks
        
        self.days = days
        
        // The values for today and this week.
        TodaysHoursMainLabel.text = FormattingHelper.formatHoursAsString(today)
        WeeksHoursMainLabel.text = FormattingHelper.formatHoursAsString(thisWeek)
        // The value for the week currently selected.
        WeeksHoursTableLabel.text = FormattingHelper.formatHoursAsString(week)
        CurrentWeekLabel.text = (FormattingHelper.weekAndYearFromDate(self.currentDate)).uppercaseString
        
        
        self.HoursCollectionView.reloadData()
        self.TasksCollectionView.reloadData()
    }
}