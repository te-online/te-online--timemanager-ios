//
//  HoursNumberFormatter.swift
//  TimeManager
//
//  Created by Thomas Ebert on 23.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import Foundation
import Charts

class HoursNumberFormatter: NSNumberFormatter {
    override func stringFromNumber(number: NSNumber) -> String? {
        return FormattingHelper.formatHoursAsString(Double(number))
    }
}

class HoursNumberFormatterXAxis: ChartXAxisValueFormatter {
    @objc func stringForXValue(index: Int, original: String, viewPortHandler: ChartViewPortHandler) -> String {
        NSLog("index %@ original %@", index, original)
//        return FormattingHelper.formatHoursAsString(Double(original)!)
        return "12 hrs."
    }
}