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
        var projectName: String!
        var clientName: String!
        var taskName: String!
        var dayValues: [Double]!
    }
    
    var tasks = [RecentTask]()
    var days = [String]()
    
    var weekTotal: Int!

    @IBOutlet weak var TodaysHoursMainLabel: UILabel!
    @IBOutlet weak var WeeksHoursMainLabel: UILabel!
    
    @IBOutlet weak var TasksCollectionView: UICollectionView!
    @IBOutlet weak var HoursCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadDummyData()
        
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

            let column = Int(floor(Double(indexPath.row) / 5))
            let row = Int(indexPath.row - (column * 5))
            
            let hours = self.tasks[row].dayValues[column] as Double
            var hoursString = ""
            
            if((hours % 2).isZero) {
                hoursString = String(Int(hours))
            } else {
                hoursString = String(round(hours * 100) / 100)
            }
            
            if(hours.isZero) {
                hoursString = ""
            }
            
            let HourValueLabel = cell.viewWithTag(1) as! UILabel
            HourValueLabel.text = hoursString
            
            if(self.tasks[row].dayValues[column].isZero) {
                let HourUnitLabel = cell.viewWithTag(2) as! UILabel
                HourUnitLabel.text = "-"
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
        let week = tt.thisWeeksRecordedHours()
        
        TodaysHoursMainLabel.text = FormattingHelper.formatHoursAsString(today)
        WeeksHoursMainLabel.text = FormattingHelper.formatHoursAsString(week)
    }
    
    func loadDummyData() {
        self.weekTotal = 45
        self.tasks = [
            RecentTask(
                projectName: "Consultation on Strategy Design",
                clientName: "Rich Industries",
                taskName: "Preparation of Meetings",
                dayValues: [10, 5, 2.5, 0, 1, 0, 0]
            ),
            RecentTask(
                projectName: "Website Relaunch",
                clientName: "Soylent Corp.",
                taskName: "Set-Up Server",
                dayValues: [2.5, 0, 10, 5, 0, 0, 0]
            ),
            RecentTask(
                projectName: "Corporate Design Manual",
                clientName: "Evil Corp.",
                taskName: "Layout",
                dayValues: [0, 2, 2.5, 0, 4, 0, 0]
            ),
            RecentTask(
                projectName: "Consultation on Strategy Design",
                clientName: "Rich Industries",
                taskName: "Fetching Coffee",
                dayValues: [0, 0, 0, 0, 1, 0, 0]
            ),
            RecentTask(
                projectName: "Personal Talent Time",
                clientName: "Warbucks Industries",
                taskName: "Literature Study",
                dayValues: [0, 0, 0, 2.5, 1, 0, 0]
            )
        ]
        self.days = [
            "MO 1.8.",
            "TU 2.8.",
            "WE 3.8.",
            "TH 4.8.",
            "FR 5.8.",
            "SA 6.8.",
            "SU 7.8."
        ]
    }
}