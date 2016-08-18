//
//  MonthChartViewController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 18.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

//
//  YearChartViewController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 18.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit
import Charts

class MonthChartViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var chartView: BarChartView!
    
    var months: [String]!
    var data: [Double]!
    
    var Colors = SharedColorPalette.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.months = ["WEEK 31 (1.8. – 7.8.)", "WEEK 32 (1.8. – 7.8.)", "WEEK 33 (1.8. – 7.8.)", "WEEK 34 (15.8. – 17.8.)"]
        self.data = [47, 37.5, 24, 15.75]
        
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
        let yl: ChartYAxis = chartView.leftAxis
        yl.labelFont = UIFont(name: "Poppins-Regular", size: 14.0)!
        yl.axisMinValue = 0.0
        yl.axisLineColor = Colors.LightGrey
        yl.labelTextColor = Colors.MediumGrey
        yl.xOffset = 22.5
        yl.axisLineWidth = 1
        yl.drawTopYLabelEntryEnabled = false
        yl.drawGridLinesEnabled = false
        yl.setLabelCount(7, force: false)
        
        // Bottom axis.
        self.chartView.rightAxis.enabled = false
        let xl: ChartXAxis = chartView.xAxis
        xl.labelFont = UIFont(name: "Poppins-Regular", size: 12.0)!
        xl.labelTextColor = Colors.MediumGrey
        xl.axisLineColor = Colors.LightGrey
        xl.yOffset = 15.0
        xl.drawGridLinesEnabled = false
        xl.labelPosition = .Bottom
        xl.axisLineWidth = 1
        
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
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Weeks")
        
        // Options for the entries
        chartDataSet.setColor(Colors.LightBlue)
        chartDataSet.drawValuesEnabled = false
        chartDataSet.highlightColor = Colors.Blue
        chartDataSet.barBorderColor = Colors.Blue
        chartDataSet.barBorderWidth = 1
        chartDataSet.barSpace = 0.75
        
        let chartData = BarChartData(xVals: months, dataSet: chartDataSet)
        self.chartView.data = chartData
        self.chartView.animate(yAxisDuration: 0.3)
    }
    
    func reloadData() {
        self.setChart(self.months, values: self.data)
    }
    
}
