//
//  FormattingHelper.swift
//  TimeManager
//
//  Created by Thomas Ebert on 16.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

class FormattingHelper {
    static var calendar: NSCalendar = NSCalendar.currentCalendar()
    
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
        return self.fullDayAndDateFromDate(date)
    }
    
    static func fullDayAndDateFromDate(date: NSDate) -> String {
        var dateFormatter: NSDateFormatter!
        // Let's create a nice date format.
        dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE d.M.y" // Monday 1.8.2016
        
        return dateFormatter.stringFromDate(date)
    }
    
    static func formatDateWithShortDayAndDate(date: NSDate) -> String {
        var dateFormatter: NSDateFormatter!
        // Let's create a nice date format.
        dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "cccccc d.M." // Mo 1.8.
        
        return dateFormatter.stringFromDate(date)
    }
    
    static func dayAndDateVeryShortFromDate(date: NSDate) -> String {
        var dateFormatter: NSDateFormatter!
        // Let's create a nice date format.
        dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEEEE, d. MMM y" // Mon, 1. Aug 2016
        
        return dateFormatter.stringFromDate(date)
    }
    
    static func dayAndDateFromDate(date: NSDate) -> String {
        var dateFormatter: NSDateFormatter!
        // Let's create a nice date format.
        dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEEEE d.M.y" // Mon 1.8.2016
        
        return dateFormatter.stringFromDate(date)
    }
    
    static func dayMonthYearFromDate(date: NSDate) -> String {
        var dateFormatter: NSDateFormatter!
        // Let's create a nice date format.
        dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd. MMMM y" // 01. August 2001
        
        return dateFormatter.stringFromDate(date)
    }
    
    static func getYearFromDate(date: NSDate) -> Int {
        let createdComponents: NSDateComponents = NSCalendar.currentCalendar().components([.Year], fromDate: date)
        return createdComponents.year
    }
    
    static func getISOStringFromDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        let enUSPosixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        return dateFormatter.stringFromDate(date)
    }
    
    static func getDateFromISOString(dateString: String) -> NSDate {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        // Always use this locale when parsing fixed format date strings
        let posix: NSLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.locale = posix
        
        return formatter.dateFromString(dateString) ?? NSDate()
    }
    
    static func weekAndYearFromDate(date: NSDate) -> String {
        var dateFormatter: NSDateFormatter!
        // Let's create a nice date format.
        dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "w / y" // 34 / 2016
        
        return "week " + dateFormatter.stringFromDate(date)
    }
    
    static func monthAndYearFromDate(date: NSDate) -> String {
        var dateFormatter: NSDateFormatter!
        // Let's create a nice date format.
        dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM y" // August 2016
        
        return dateFormatter.stringFromDate(date)
    }
}
