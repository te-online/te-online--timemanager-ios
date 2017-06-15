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
    @IBOutlet weak var DetailsHoursLabel: UILabel!
    
    var months: [String]!
    var data: [Double]!
    
    var Colors = SharedColorPalette.sharedInstance
    var tt: TimeTraveller!
    
    var dateProjects = [ProjectObject]()
    var currentProject: ProjectObject!
    var rawValues: [Double] = []
    
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
        let lA: YAxis = chartView.leftAxis
        lA.enabled = false
        
        let yl: XAxis = chartView.xAxis
        yl.enabled = false
        
        // Bottom axis.
        self.chartView.rightAxis.enabled = true
        let xl: YAxis = chartView.rightAxis
        xl.labelFont = UIFont(name: "Poppins-Regular", size: 12.0)!
        xl.labelTextColor = Colors.MediumGrey
        xl.axisLineColor = Colors.LightGrey
        xl.drawGridLinesEnabled = false
        xl.labelPosition = .OutsideChart
        xl.axisLineWidth = 0
        xl.drawAxisLineEnabled = false
        xl.valueFormatter = NumberFormatter() as! IAxisValueFormatter
        xl.valueFormatter?.maximumFractionDigits = 0
        
        self.chartView.extraLeftOffset = -100.0
        
        // No border.
        self.chartView.borderLineWidth = 0
        
        // No legend.
        self.chartView.legend.enabled = false
        
        self.tt = TimeTraveller()
        
        // Set the data.
        self.reloadData(Date())
        
        // Set detail hours to zero.
        self.DetailsHoursLabel.text = FormattingHelper.formatHoursAsString(0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChart(_ dataPoints: [String], values: [Double]) {
        self.chartView.noDataText = "No data."
        
        var dataEntries: [BarChartDataEntry] = []
        
        let dataEntry = BarChartDataEntry(values: values, xIndex: 0)
        dataEntries.append(dataEntry)
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Weeks")
        
        // Options for the entries
        chartDataSet.setColor(Colors.LightBlue)
        chartDataSet.valueFont = UIFont(name: "Poppins-Regular", size: 14.0)!
        chartDataSet.valueTextColor = Colors.DarkGrey
        chartDataSet.highlightColor = Colors.Blue
        chartDataSet.barBorderColor = UIColor.white
        chartDataSet.barBorderWidth = 2
        chartDataSet.drawValuesEnabled = false
        chartDataSet.valueFormatter = HoursNumberFormatter() as! IValueFormatter
        
        let chartData = BarChartData(xVals: months, dataSet: chartDataSet)
        self.chartView.data = chartData
        self.chartView.animate(yAxisDuration: 0.3)
        self.chartView.highlightValue(nil)
    }
    
    // Give some orientation, where the user is.
    func reloadData(_ forDate: Date) {
        if(self.tt == nil) {
            self.tt = TimeTraveller()
        }
        
        self.rawValues = tt.recordedHoursInProjectsByDate(forDate)
        self.dateProjects = tt.ProjectsByDate(forDate)
        self.setChart(self.months, values: self.rawValues)
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: Highlight) {
        // Once a value is selected, we search for the correspoding project object in our list and display the data.
        let index = (highlight.stackIndex < 0) ? 0 : highlight.stackIndex
        if(self.dateProjects.count > index) {
            self.currentProject = self.dateProjects[index]
            self.DetailsTableView.reloadData()
            
            self.DetailsHoursLabel.text = FormattingHelper.formatHoursAsString(self.rawValues[index])
        }
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        self.currentProject = nil
        self.DetailsHoursLabel.text = FormattingHelper.formatHoursAsString(0)
        self.DetailsTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    // Format the cells; the client cell, the project cell and the cell when there is no selection.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell = UITableViewCell()
        
        if(indexPath.section == 0) {
            cell = tableView.dequeueReusableCell(withIdentifier: "client")!
            cell.textLabel?.font = UIFont(name: "Poppins-Medium", size: 20.0)!
            cell.textLabel?.textColor = Colors.Blue
            if self.currentProject != nil {
                cell.textLabel!.text = (self.currentProject.client! as ClientObject).name
            } else {
                cell.textLabel!.text = "Select a project to see details."
            }
        } else if(indexPath.section == 1) {
            cell = tableView.dequeueReusableCell(withIdentifier: "subitem")!
            cell.textLabel?.font = UIFont(name: "Poppins-Medium", size: 16.0)!
            cell.textLabel?.textColor = Colors.DarkGrey
            if self.currentProject != nil {
                cell.textLabel!.text = self.currentProject.name
            } else {
                cell.textLabel!.text = "-"
            }
        } else if(indexPath.section == 2) {
            cell = tableView.dequeueReusableCell(withIdentifier: "subitem")!
            cell.textLabel?.font = UIFont(name: "Poppins-Regular", size: 16.0)!
            cell.textLabel?.textColor = Colors.DarkGrey
            if self.currentProject != nil {
                cell.textLabel!.text = (self.currentProject.tasks?.allObjects[indexPath.row] as! TaskObject).name
            } else {
                cell.textLabel!.text = "-"
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 && self.currentProject != nil {
            return self.currentProject.tasks!.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0) {
            return "For client"
        } else if(section == 1) {
            return "Project"
        }
        return "Tasks"
    }
    
    // Add a nicely formatted section header to the table view.
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 15, y: 8, width: 320, height: 20)
        myLabel.font = UIFont(name: "Poppins-Regular", size: 10.0)!
        myLabel.textColor = Colors.Grey
        myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)?.uppercased()
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        headerView.addSubview(myLabel)
        
        return headerView
    }
    
}
