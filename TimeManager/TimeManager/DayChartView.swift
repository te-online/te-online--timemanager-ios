//
//  DayChartView.swift
//  TimeManager
//
//  Created by Thomas Ebert on 18.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit
import Charts

class DayChartView: UIViewController, ChartViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var chartView: HorizontalBarChartView!
    @IBOutlet weak var DetailsTableView: UITableView!
    
    var months: [String]!
    var data: [Double]!
    
    var Colors = SharedColorPalette.sharedInstance
    
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
//        yl.labelFont = UIFont(name: "Poppins-Regular", size: 14.0)!
//        yl.axisMinValue = 0.0
//        yl.axisLineColor = Colors.LightGrey
//        yl.axisLineWidth = 0
//        yl.drawAxisLineEnabled = false
//        yl.labelTextColor = Colors.MediumGrey
////        yl.xOffset = 22.5
//        yl.yOffset = 20
//        yl.labelPosition = .InsideChart
//        yl.axisLineWidth = 1
//        yl.drawTopYLabelEntryEnabled = false
//        yl.drawGridLinesEnabled = false
////        yl.line
//        yl.setLabelCount(9, force: false)
        
        // Bottom axis.
        self.chartView.rightAxis.enabled = true
        let xl: ChartYAxis = chartView.rightAxis
        xl.labelFont = UIFont(name: "Poppins-Regular", size: 12.0)!
        xl.labelTextColor = Colors.MediumGrey
        xl.axisLineColor = Colors.LightGrey
//        xl.yOffset = -20.0
        xl.drawGridLinesEnabled = false
        xl.labelPosition = .OutsideChart
        xl.axisLineWidth = 0
        xl.drawAxisLineEnabled = false
        
        self.chartView.extraLeftOffset = -100.0
        
        // No border.
        self.chartView.borderLineWidth = 0
        
        // No legend.
        self.chartView.legend.enabled = false
        
        // Set the data.
        self.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        self.chartView.noDataText = "No data."
        
        var dataEntries: [BarChartDataEntry] = []
        
//        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(values: values, xIndex: 0)
            dataEntries.append(dataEntry)
//        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Weeks")
        
        // Options for the entries
        chartDataSet.setColor(Colors.LightBlue)
//        chartDataSet.axisDependency = .Right
        chartDataSet.valueFont = UIFont(name: "Poppins-Regular", size: 14.0)!
        chartDataSet.valueTextColor = Colors.MediumGrey
        chartDataSet.highlightColor = Colors.Blue
        chartDataSet.barBorderColor = UIColor.whiteColor()
        chartDataSet.barBorderWidth = 2
        chartDataSet.drawValuesEnabled = false
//        chartDataSet.barSpace = 0.0
//        chartDataSet.barSpace = 0
        
        let chartData = BarChartData(xVals: months, dataSet: chartDataSet)
        self.chartView.data = chartData
        self.chartView.animate(yAxisDuration: 0.3)
    }
    
    func reloadData() {
        self.setChart(self.months, values: self.data)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        if(indexPath.section == 0) {
            cell = tableView.dequeueReusableCellWithIdentifier("client")!
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("subitem")!
        }
        
        cell.textLabel!.text = "Rich Industries"
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
