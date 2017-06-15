//
//  HoursNumberFormatter.swift
//  TimeManager
//
//  Created by Thomas Ebert on 23.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import Foundation
import Charts

class HoursNumberFormatter: NumberFormatter {
    // Format chart labels as hour values.
    override func string(from number: NSNumber) -> String? {
        return FormattingHelper.formatHoursAsString(Double(number))
    }
}
