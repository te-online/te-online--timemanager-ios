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
    
    enum DateFormat {
        case WeekAndDaySpan // Week 31 (1.8. – 7.8.)
        case DayAndMonthShort // 1.8.
        case DaynameDayMonthnameYear // Thu, 22. Aug 2001
        case HoursMinutes // 9.00
        case DayMonthnameYear // 15. August 2001
    }
    
    static func formatHoursAsString(hours: Double) -> String {
        var hoursString = ""
        
        hoursString += String.localizedStringWithFormat("%g", hours)
        
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
        
        return "Week " + dateFormatter.stringFromDate(date)
    }
    
    static func monthAndYearFromDate(date: NSDate) -> String {
        var dateFormatter: NSDateFormatter!
        // Let's create a nice date format.
        dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM y" // August 2016
        
        return dateFormatter.stringFromDate(date)
    }
    
    static func dateFormat(format: DateFormat, date: NSDate) -> String {
        var result = ""
        // Let's create a nice date format.
        var dateFormatter: NSDateFormatter!
        dateFormatter = NSDateFormatter()

        if format == .WeekAndDaySpan {
            dateFormatter.dateFormat = "w" // 34
            result += "Week " + dateFormatter.stringFromDate(date) + " / "
            result += self.dateFormat(.DayAndMonthShort, date: DateHelper.getFirstDayOfWeekByDate(date))
            result += " – "
            result += self.dateFormat(.DayAndMonthShort, date: DateHelper.getLastDayOfWeekByDate(date))
        }
        if format == .DayAndMonthShort {
            dateFormatter.dateFormat = "d.M." // 1.8.
            result += dateFormatter.stringFromDate(date)
        }
        if format == .DaynameDayMonthnameYear {
            dateFormatter.dateFormat = "EEE, d. MMM y" // Thu, 22. Aug 2001
            result += dateFormatter.stringFromDate(date)
        }
        if format == .HoursMinutes {
            dateFormatter.dateFormat = "k.mm" // 9.00
            result += dateFormatter.stringFromDate(date)
        }
        if format == .DayMonthnameYear {
            dateFormatter.dateFormat = "d. MMMM y" // 15. August 2001
            result += dateFormatter.stringFromDate(date)
        }
        
        return result
    }
}
