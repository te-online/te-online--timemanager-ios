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
    var currentDate = Date()
    
    var weekTotal: Int!

    @IBOutlet weak var TodaysHoursMainLabel: UILabel!
    @IBOutlet weak var WeeksHoursMainLabel: UILabel!
    @IBOutlet weak var WeeksHoursTableLabel: UILabel!
    
    @IBOutlet weak var CurrentWeekLabel: UILabel!
    @IBOutlet weak var NoEntriesLabel: UILabel!
    
    @IBOutlet weak var TasksCollectionView: UICollectionView!
    @IBOutlet weak var HoursCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // We are delegate for the list of tasks.
        TasksCollectionView.delegate = self
        TasksCollectionView.dataSource = self
        
        // We are also delegate for the grid of hours.
        HoursCollectionView.delegate = self
        HoursCollectionView.dataSource = self
        
        self.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadData()
        super.viewWillAppear(animated)
    }

    @IBAction func NavigateToPreviousWeekButtonPressed(_ sender: AnyObject) {
        // Subtract one week from the current date.
        self.currentDate = DateHelper.getDateFor(.previousWeek, date: self.currentDate)
        self.loadData()
    }
    
    @IBAction func NavigateToNextWeekButtonPressed(_ sender: AnyObject) {
        // Add one week to the current date.
        self.currentDate = DateHelper.getDateFor(.nextWeek, date: self.currentDate)
        self.loadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == TasksCollectionView) {
            return self.tasks.count
        } else if(collectionView == HoursCollectionView) {
            // There are 5 rows, times 7 day, equals 35 cells in total.
            return 35
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Configure the cell to have the task, project and client inside.
        if(collectionView == TasksCollectionView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "taskCell", for: indexPath) as UICollectionViewCell
            
            let ProjectNameLabel = cell.viewWithTag(1) as! UILabel
            ProjectNameLabel.text = self.tasks[indexPath.row].projectName
            
            let TaskNameLabel = cell.viewWithTag(2) as! UILabel
            TaskNameLabel.text = "> " + self.tasks[indexPath.row].taskName
            
            let ClientNameLabel = cell.viewWithTag(3) as! UILabel
            ClientNameLabel.text = self.tasks[indexPath.row].clientName
            
            return cell
        } else if(collectionView == HoursCollectionView) {
            // Configure the cell to show the correct value in the grid.
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourCell", for: indexPath) as UICollectionViewCell
            
            // Get the row and column of this cell in our grid.
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
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath) as UICollectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableView: UICollectionReusableView!
        reusableView = nil
        
        // Add the names of the days to the header view.
        if(kind == UICollectionElementKindSectionHeader) {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "hoursDayLegend", for: indexPath)
            
            for i in 1...7 {
                let Label = headerView.viewWithTag(i) as! UILabel
                Label.text = self.days[i-1]
            }
            
            reusableView = headerView
        }
        
        return reusableView
    }
    
    func loadData() {
        // Load all the data for the current selected week.
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
        
        if entries.count > 0 {
            NoEntriesLabel.alpha = 0
        } else {
            NoEntriesLabel.alpha = 1
        }
        
        self.tasks = newTasks
        
        self.days = days
        
        // The values for today and this week.
        TodaysHoursMainLabel.text = FormattingHelper.formatHoursAsString(today)
        WeeksHoursMainLabel.text = FormattingHelper.formatHoursAsString(thisWeek)
        // The value for the week currently selected.
        WeeksHoursTableLabel.text = FormattingHelper.formatHoursAsString(week)
        CurrentWeekLabel.text = (FormattingHelper.dateFormat(.WeekAndYear, date: self.currentDate).uppercaseString).uppercased()
        
        
        self.HoursCollectionView.reloadData()
        self.TasksCollectionView.reloadData()
    }
}
