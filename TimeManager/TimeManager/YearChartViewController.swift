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
    
    var options: [[String: String]]!
    var months: [String]!
    var hours: [Double]!
    
    var Colors = SharedColorPalette.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
        self.hours = [100, 120, 130, 20, 50, 60, 75, 230, 45, 98, 12, 25]
        
//        self.title = "Scatter Bar Chart"
//        self.options = [["key": "toggleValues", "label": "Toggle Values"], ["key": "toggleHighlight", "label": "Toggle Highlight"], ["key": "animateX", "label": "Animate X"], ["key": "animateY", "label": "Animate Y"], ["key": "animateXY", "label": "Animate XY"], ["key": "saveToGallery", "label": "Save to Camera Roll"], ["key": "togglePinchZoom", "label": "Toggle PinchZoom"], ["key": "toggleAutoScaleMinMax", "label": "Toggle auto scale min/max"], ["key": "toggleData", "label": "Toggle Data"]]
        
        self.chartView.delegate = self
        self.chartView.descriptionText = ""
//        self.chartView.noDataTextDescription = "You need to provide data for the chart."
        self.chartView.drawGridBackgroundEnabled = false
        self.chartView.dragEnabled = false
        chartView.scaleXEnabled = false
        chartView.scaleYEnabled = false
//        self.chartView.maxVisibleValueCount = 200
        self.chartView.pinchZoomEnabled = false
//        var l: ChartLegend = chartView.legend
//        l.position = .RightOfChart
//        l.font = UIFont(name: "Poppins-Regular", size: 14.0)!
//        l.xOffset = 5.0
        let yl: ChartYAxis = chartView.leftAxis
        yl.labelFont = UIFont(name: "Poppins-Regular", size: 14.0)!
        yl.axisMinValue = 0.0
        yl.axisLineColor = Colors.LightGrey
        yl.labelTextColor = Colors.MediumGrey
        yl.xOffset = 22.5
        // this replaces startAtZero = YES
        self.chartView.rightAxis.enabled = false
        let xl: ChartXAxis = chartView.xAxis
        xl.labelFont = UIFont(name: "Poppins-Regular", size: 14.0)!
        xl.labelTextColor = Colors.MediumGrey
        xl.axisLineColor = Colors.LightGrey
        xl.yOffset = 15.0
        xl.drawGridLinesEnabled = false
        
        // Custom
        self.chartView.borderLineWidth = 0
        self.chartView.xAxis.labelPosition = .Bottom
        self.chartView.xAxis.axisLineWidth = 1
        self.chartView.leftAxis.axisLineWidth = 1
//        self.chartView.xAxis.
        self.chartView.legend.enabled = false
        self.chartView.leftAxis.drawTopYLabelEntryEnabled = false
//        self.chartView.leftAxis.drawLabelsEnabled = false
        self.chartView.leftAxis.drawGridLinesEnabled = false
        self.chartView.leftAxis.setLabelCount(7, force: false)
        self.chartView.drawMarkers = false
//        self.chartView.leftAxis.spaceTop = 0.3
        self.setChart(self.months, values: self.hours)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        self.chartView.noDataText = "No data."
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = ScatterChartDataSet(yVals: dataEntries, label: "Months")
        chartDataSet.setColor(Colors.MediumBlue)
        chartDataSet.drawValuesEnabled = false
        chartDataSet.scatterShape = .Circle
        chartDataSet.scatterShapeSize = 16
        chartDataSet.highlightColor = Colors.LightBlue
        
        let chartData = ScatterChartData(xVals: months, dataSet: chartDataSet)
        self.chartView.data = chartData
        self.chartView.animate(yAxisDuration: 0.3)
    }
    
}
