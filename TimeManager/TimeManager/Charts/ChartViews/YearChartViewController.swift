//
//  YearChartViewController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 18.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit
import Charts

class YearChartViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var chartView: ScatterChartView!
    
    var months: [String]!
    var data: [Double]!
    
    var Colors = SharedColorPalette.sharedInstance
    var tt: TimeTraveller!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
        self.data = [100, 120, 130, 20, 50, 60, 75, 230, 45, 98, 12, 25]
        
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
        let yl: YAxis = chartView.leftAxis
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
        let xl: XAxis = chartView.xAxis
        xl.labelFont = UIFont(name: "Poppins-Regular", size: 14.0)!
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
        
        self.tt = TimeTraveller()
        
        // Set the data.
        self.reloadData(Date())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChart(_ dataPoints: [String], values: [Double]) {
        self.chartView.noDataText = "No data."
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: values[i], y: Double(i))
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = ScatterChartDataSet(values: dataEntries, label: "Months")
        
        // Options for the entries
        chartDataSet.setColor(Colors.MediumBlue)
        chartDataSet.drawValuesEnabled = false
        chartDataSet.scatterShape = .Circle
        chartDataSet.scatterShapeSize = 16
        chartDataSet.highlightColor = Colors.LightBlue
        
        let chartData = ScatterChartData(xVals: months, dataSet: chartDataSet)
        self.chartView.data = chartData
        self.chartView.animate(yAxisDuration: 0.3)
        self.chartView.highlightValue(nil)
    }
    
    func reloadData(_ forDate: Date) {
        // Give some orientation, where the user is.
        if(self.tt == nil) {
            self.tt = TimeTraveller()
        }
        
        let values = tt.getHoursForYearByDate(forDate)
        self.setChart(self.months, values: values)
    }
    
}
