//
//  WeekChartView.swift
//  TimeManager
//
//  Created by Thomas Ebert on 18.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit
import Charts

class WeekChartViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var chartView: BarChartView!
    
    var months: [String]!
    var data: [Double]!
    
    var Colors = SharedColorPalette.sharedInstance
    var tt: TimeTraveller!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.months = ["MO 1.8.", "TU 2.8.", "WE 3.8.", "TH 4.8.", "FR 5.8.", "SA 6.8.", "SU 7.8."]
        self.data = [5, 8.5, 2.75, 7.5, 7, 0, 0]
        
        self.chartView.delegate = self
        
        // No description text.
        self.chartView.chartDescription?.text = ""
        
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
        yl.axisMinimum = 0.0
        yl.axisLineColor = Colors.LightGrey
        yl.labelTextColor = Colors.MediumGrey
        yl.xOffset = 27.5
        yl.axisLineWidth = 1
        yl.drawTopYLabelEntryEnabled = false
        yl.drawGridLinesEnabled = false
        yl.setLabelCount(7, force: false)
        yl.valueFormatter = NumberFormatter() as! IAxisValueFormatter
        // TOOD: yl.valueFormatter?.maximumFractionDigits = 0
        
        // Bottom axis.
        self.chartView.rightAxis.enabled = false
        let xl: XAxis = chartView.xAxis
        xl.labelFont = UIFont(name: "Poppins-Regular", size: 12.0)!
        xl.labelTextColor = Colors.MediumGrey
        xl.axisLineColor = Colors.LightGrey
        xl.yOffset = 15.0
        xl.drawGridLinesEnabled = false
        xl.labelPosition = .bottom
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
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry as! BarChartDataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Weeks")
        
        // Options for the entries
        chartDataSet.setColor(Colors.LightBlue)
        chartDataSet.valueFont = UIFont(name: "Poppins-Regular", size: 14.0)!
        chartDataSet.valueTextColor = Colors.MediumGrey
        chartDataSet.highlightColor = Colors.Blue
        chartDataSet.barBorderColor = Colors.Blue
        chartDataSet.barBorderWidth = 1
        // TODO: chartDataSet.barSpace = 0.55
        chartDataSet.valueFormatter = HoursNumberFormatter() as? IValueFormatter
        
        let chartData = BarChartData(dataSet: chartDataSet)
        // TODO: xVals: months, 
        self.chartView.data = chartData
        self.chartView.animate(yAxisDuration: 0.3)
        self.chartView.highlightValue(nil)
    }
    
    func reloadData(_ forDate: Date) {
        if(self.tt == nil) {
            self.tt = TimeTraveller()
        }

        let days = tt.daysOfWeekFromDate(forDate)
        let values = tt.recordedHoursForWeekByDate(forDate)
        self.setChart(days, values: values)
    }
    
}


