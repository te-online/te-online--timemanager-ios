//
//  DayChartView.swift
//  TimeManager
//
//  Created by Thomas Ebert on 18.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit
import Charts

class DayChartViewController: UIViewController, ChartViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var chartView: HorizontalBarChartView!
    @IBOutlet weak var DetailsTableView: UITableView!
    
    var months: [String]!
    var data: [Double]!
    
    var Colors = SharedColorPalette.sharedInstance
    var tt: TimeTraveller!
    
    var dateProjects = [ProjectObject]()
    var currentProject: ProjectObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.DetailsTableView.delegate = self
        self.DetailsTableView.dataSource = self
        
        self.months = [""]
        self.data = [1.75, 3, 2, 2, 1.25]
        
        self.chartView.delegate = self
        // No description text.
        self.chartView.descriptionText = ""
        
        // No grid.
        self.chartView.drawGridBackgroundEnabled = false
        
        // No interactions.
        self.chartView.dragEnabled = false
        self.chartView.scaleXEnabled = false
        self.chartView.scaleYEnabled = false
        self.chartView.pinchZoomEnabled = false
        
        // Left axis.
        let lA: ChartYAxis = chartView.leftAxis
        lA.enabled = false
        
        let yl: ChartXAxis = chartView.xAxis
        yl.enabled = false
        
        // Bottom axis.
        self.chartView.rightAxis.enabled = true
        let xl: ChartYAxis = chartView.rightAxis
        xl.labelFont = UIFont(name: "Poppins-Regular", size: 12.0)!
        xl.labelTextColor = Colors.MediumGrey
        xl.axisLineColor = Colors.LightGrey
        xl.drawGridLinesEnabled = false
        xl.labelPosition = .OutsideChart
        xl.axisLineWidth = 0
        xl.drawAxisLineEnabled = false
        xl.valueFormatter = NSNumberFormatter()
        xl.valueFormatter?.maximumFractionDigits = 0
        
        self.chartView.extraLeftOffset = -100.0
        
        // No border.
        self.chartView.borderLineWidth = 0
        
        // No legend.
        self.chartView.legend.enabled = false
        
        self.tt = TimeTraveller()
        
        // Set the data.
        self.reloadData(NSDate())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        self.chartView.noDataText = "No data."
        
        var dataEntries: [BarChartDataEntry] = []
        
        let dataEntry = BarChartDataEntry(values: values, xIndex: 0)
        dataEntries.append(dataEntry)
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Weeks")
        
        // Options for the entries
        chartDataSet.setColor(Colors.LightBlue)
        chartDataSet.valueFont = UIFont(name: "Poppins-Regular", size: 14.0)!
        chartDataSet.valueTextColor = Colors.DarkGrey
        chartDataSet.highlightColor = Colors.Blue
        chartDataSet.barBorderColor = UIColor.whiteColor()
        chartDataSet.barBorderWidth = 2
        chartDataSet.drawValuesEnabled = false
        chartDataSet.valueFormatter = HoursNumberFormatter()
        
        let chartData = BarChartData(xVals: months, dataSet: chartDataSet)
        self.chartView.data = chartData
        self.chartView.animate(yAxisDuration: 0.3)
    }
    
    func reloadData(forDate: NSDate) {
        if(self.tt == nil) {
            self.tt = TimeTraveller()
        }
        
        let rawValues = tt.recordedHoursInProjectsByDate(forDate)
        self.dateProjects = tt.ProjectsByDate(forDate)
        self.setChart(self.months, values: rawValues)
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        let index = (highlight.stackIndex < 0) ? 0 : highlight.stackIndex
        if(self.dateProjects.count > index) {
            self.currentProject = self.dateProjects[index]
            self.DetailsTableView.reloadData()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = UITableViewCell()
        
        if(indexPath.section == 0) {
            cell = tableView.dequeueReusableCellWithIdentifier("client")!
            if self.currentProject != nil {
                cell.textLabel!.text = (self.currentProject.client! as ClientObject).name
            } else {
                cell.textLabel!.text = "Select a project to see details."
            }
        } else if(indexPath.section == 1) {
            cell = tableView.dequeueReusableCellWithIdentifier("subitem")!
            if self.currentProject != nil {
                cell.textLabel!.text = self.currentProject.name
            } else {
                cell.textLabel!.text = "-"
            }
        } else if(indexPath.section == 2) {
            cell = tableView.dequeueReusableCellWithIdentifier("subitem")!
            if self.currentProject != nil {
                cell.textLabel!.text = (self.currentProject.tasks?.allObjects[indexPath.row] as! TaskObject).name
            } else {
                cell.textLabel!.text = "-"
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 && self.currentProject != nil {
            return self.currentProject.tasks!.count
        }
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0) {
            return "FOR"
        } else if(section == 1) {
            return "PROJECT"
        }
        return "TASKS"
    }
    
}
