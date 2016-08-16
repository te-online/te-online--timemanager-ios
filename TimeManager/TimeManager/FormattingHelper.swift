//
//  FormattingHelper.swift
//  TimeManager
//
//  Created by Thomas Ebert on 16.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

class FormattingHelper {
    static func formatHoursAsString(hours: Double) -> String {
        var hoursString = ""
        
        // If the hour is a whole number we don't want commas.
//        if hours%1 == 0 {
//            hoursString = hoursString + String(Int(hours))
//        } else {
//            hoursString = hoursString + String.localizedStringWithFormat("%.2f", hours)
//        }
        hoursString += String(format: "%g", hours)
        
        // One hour vs multiple or zero hours.
        if hours != 1 {
            hoursString += " hrs."
        } else {
            hoursString += " hr."
        }
        
        return hoursString
    }
    
    static func formatSomeNumberWithUnit(number: Int, unitSingular: String, unitPlural: String) -> String {
        var numberString = String(number)
        
        // One hour vs multiple or zero hours.
        if number == 1 {
            numberString += " " + unitSingular
        } else {
            numberString += " " + unitPlural
        }
        
        return numberString
    }
    
    static func formatNiceDayFromDateAsString(date: NSDate) -> String {
        var dateFormatter: NSDateFormatter!
        // Let's create a nice date format.
        dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .NoStyle
        
        return dateFormatter.stringFromDate(date)
    }
    
    static func getYearFromDate(date: NSDate) -> Int {
        let createdComponents: NSDateComponents = NSCalendar.currentCalendar().components([.Year], fromDate: date)
        return createdComponents.year
    }
}
