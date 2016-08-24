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
        case WeekAndDaySpan             // Week 31 (1.8. – 7.8.)
        case DayAndMonthShort           // 1.8.
        case DaynameDayMonthnameYear    // Thu, 22. Aug 2001
        case HoursMinutes               // 9.00
        case DayMonthnameYear           // 15. August 2001
        case DaynameAndDate             // Monday 1.8.2016
        case ShortDaynameDayMonth       // Mo 1.8.
        case ShortDaynameDayMonthYear   // Mon 1.8.2016
        case ISOString                  // 2016-08-01T23:49:25+02:00
        case WeekAndYear                // 34 / 2016
        case MonthAndYear               // August 2016
    }
    
    // Formats a plain Double as hours. E.g. 12.0 -> "12 hrs." / 0.75 -> "0.75 hrs."
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
    
    // Adds a unit to a simple number. E.g. (2, project, projects) -> "2 projects"
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
    
    // Gets the year as integer from a date object.
    static func getYearFromDate(date: NSDate) -> Int {
        let createdComponents: NSDateComponents = NSCalendar.currentCalendar().components([.Year], fromDate: date)
        return createdComponents.year
    }
    
    // Gets a date object from a given ISO Time String.
    static func getDateFromISOString(dateString: String) -> NSDate {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        // Always use this locale when parsing fixed format date strings
        let posix: NSLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.locale = posix
        
        return formatter.dateFromString(dateString) ?? NSDate()
    }
    
    // Formats a date as a string with a given format from a set of formats.
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
        else if format == .DayAndMonthShort {
            dateFormatter.dateFormat = "d.M." // 1.8.
            result += dateFormatter.stringFromDate(date)
        }
        else if format == .DaynameDayMonthnameYear {
            dateFormatter.dateFormat = "EEE, d. MMM y" // Thu, 22. Aug 2001
            result += dateFormatter.stringFromDate(date)
        }
        else if format == .HoursMinutes {
            dateFormatter.dateFormat = "k.mm" // 9.00
            result += dateFormatter.stringFromDate(date)
        }
        else if format == .DayMonthnameYear {
            dateFormatter.dateFormat = "d. MMMM y" // 15. August 2001
            result += dateFormatter.stringFromDate(date)
        }
        else if format == .DaynameAndDate {
            dateFormatter.dateFormat = "EEEE d.M.y"
            result += dateFormatter.stringFromDate(date)
        }
        else if format == .ShortDaynameDayMonth {
            dateFormatter.dateFormat = "cccccc d.M."
            result += dateFormatter.stringFromDate(date)
        }
        else if format == .ShortDaynameDayMonthYear {
            dateFormatter.dateFormat = "EEEEEE d.M.y"
            result += dateFormatter.stringFromDate(date)
        }
        else if format == .ISOString {
            let enUSPosixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
            dateFormatter.locale = enUSPosixLocale
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            
            result += dateFormatter.stringFromDate(date)
        }
        else if format == .WeekAndYear {
            dateFormatter.dateFormat = "w / y"
            result += dateFormatter.stringFromDate(date)
        }
        else if format == .MonthAndYear {
            dateFormatter.dateFormat = "MMMM y"
            result += dateFormatter.stringFromDate(date)
        }
        
        return result
    }
}
