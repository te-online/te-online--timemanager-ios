//
//  FormattingHelper.swift
//  TimeManager
//
//  Created by Thomas Ebert on 16.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

class FormattingHelper {
    static var calendar: Calendar = Calendar.current
    
    enum DateFormat {
        case weekAndDaySpan             // Week 31 (1.8. – 7.8.)
        case dayAndMonthShort           // 1.8.
        case daynameDayMonthnameYear    // Thu, 22. Aug 2001
        case hoursMinutes               // 9.00
        case dayMonthnameYear           // 15. August 2001
        case daynameAndDate             // Monday 1.8.2016
        case shortDaynameDayMonth       // Mo 1.8.
        case shortDaynameDayMonthYear   // Mon 1.8.2016
        case isoString                  // 2016-08-01T23:49:25+02:00
        case weekAndYear                // 34 / 2016
        case monthAndYear               // August 2016
    }
    
    // Formats a plain Double as hours. E.g. 12.0 -> "12 hrs." / 0.75 -> "0.75 hrs."
    static func formatHoursAsString(_ hours: Double) -> String {
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
    static func formatSomeNumberWithUnit(_ number: Int, unitSingular: String, unitPlural: String) -> String {
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
    static func getYearFromDate(_ date: Date) -> Int {
        let createdComponents: DateComponents = (Calendar.current as NSCalendar).components([.year], from: date)
        return createdComponents.year!
    }
    
    // Gets a date object from a given ISO Time String.
    static func getDateFromISOString(_ dateString: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        // Always use this locale when parsing fixed format date strings
        let posix: Locale = Locale(identifier: "en_US_POSIX")
        formatter.locale = posix
        
        return formatter.date(from: dateString) ?? Date()
    }
    
    // Formats a date as a string with a given format from a set of formats.
    static func dateFormat(_ format: DateFormat, date: Date) -> String {
        var result = ""
        // Let's create a nice date format.
        var dateFormatter: DateFormatter!
        dateFormatter = DateFormatter()

        if format == .weekAndDaySpan {
            dateFormatter.dateFormat = "w" // 34
            result += "Week " + dateFormatter.string(from: date) + " / "
            result += self.dateFormat(.dayAndMonthShort, date: DateHelper.getFirstDayOfWeekByDate(date))
            result += " – "
            result += self.dateFormat(.dayAndMonthShort, date: DateHelper.getLastDayOfWeekByDate(date))
        }
        else if format == .dayAndMonthShort {
            dateFormatter.dateFormat = "d.M." // 1.8.
            result += dateFormatter.string(from: date)
        }
        else if format == .daynameDayMonthnameYear {
            dateFormatter.dateFormat = "EEE, d. MMM y" // Thu, 22. Aug 2001
            result += dateFormatter.string(from: date)
        }
        else if format == .hoursMinutes {
            dateFormatter.dateFormat = "k.mm" // 9.00
            result += dateFormatter.string(from: date)
        }
        else if format == .dayMonthnameYear {
            dateFormatter.dateFormat = "d. MMMM y" // 15. August 2001
            result += dateFormatter.string(from: date)
        }
        else if format == .daynameAndDate {
            dateFormatter.dateFormat = "EEEE d.M.y"
            result += dateFormatter.string(from: date)
        }
        else if format == .shortDaynameDayMonth {
            dateFormatter.dateFormat = "cccccc d.M."
            result += dateFormatter.string(from: date)
        }
        else if format == .shortDaynameDayMonthYear {
            dateFormatter.dateFormat = "EEEEEE d.M.y"
            result += dateFormatter.string(from: date)
        }
        else if format == .isoString {
            let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
            dateFormatter.locale = enUSPosixLocale
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            result += dateFormatter.string(from: date)
        }
        else if format == .weekAndYear {
            dateFormatter.dateFormat = "w / y"
            result += dateFormatter.string(from: date)
        }
        else if format == .monthAndYear {
            dateFormatter.dateFormat = "MMMM y"
            result += dateFormatter.string(from: date)
        }
        
        return result
    }
}
