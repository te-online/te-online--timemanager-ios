//
//  DateHelper.swift
//  TimeManager
//
//  Created by Thomas Ebert on 22.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

class DateHelper {
    static let calendar = NSCalendar.currentCalendar()
    
    enum ShiftType {
        case PreviousDay
        case NextDay
        case PreviousWeek
        case NextWeek
        case PreviousMonth
        case NextMonth
        case PreviousYear
        case NextYear
    }
    
    static func getDateFor(dateType: ShiftType, date: NSDate) -> NSDate {
        let components = NSDateComponents()
        
        if(dateType == .PreviousDay) {
            components.day = -1
        } else if(dateType == .NextDay) {
            components.day = 1
        } else if(dateType == .PreviousWeek) {
            components.weekOfYear = -1
        } else if(dateType == .NextWeek) {
            components.weekOfYear = 1
        } else if(dateType == .PreviousMonth) {
            components.month = -1
        } else if(dateType == .NextMonth) {
            components.month = 1
        } else if(dateType == .PreviousYear) {
            components.year = -1
        }  else if(dateType == .NextYear) {
            components.year = 1
        }
        
        return self.calendar.dateByAddingComponents(components, toDate: date, options: []) ?? NSDate()
    }
    
    static func getFirstDayOfYearByDate(date: NSDate) -> NSDate {
        let components = calendar.components([.Year], fromDate: date)
        
        return calendar.dateFromComponents(components) ?? NSDate()
    }
    
    static func getLastDayOfYearByDate(date: NSDate) -> NSDate {
        let components = calendar.components([.Year], fromDate: date)
        components.year = 1
//        components.day = -1
        
        NSLog(String(calendar.dateByAddingComponents(components, toDate: self.getFirstDayOfYearByDate(date), options: [])))
        
        return calendar.dateByAddingComponents(components, toDate: self.getFirstDayOfYearByDate(date), options: []) ?? NSDate()
    }
    
    static func getFirstDayOfMonthByDate(date: NSDate) -> NSDate {
        let components = calendar.components([.Year, .Month], fromDate: date)
        
        return calendar.dateFromComponents(components) ?? NSDate()
    }
    
    static func getLastDayOfMonthByDate(date: NSDate) -> NSDate {
        let components = calendar.components([.Month], fromDate: date)
        components.month = 1
        
        return calendar.dateByAddingComponents(components, toDate: self.getFirstDayOfMonthByDate(date), options: []) ?? NSDate()
    }
    
    static func getMonthNum(date: NSDate) -> Int {
        let components = calendar.components([.Year, .Month], fromDate: date)
        
        return components.month
    }
    
    static func getFirstDayOfWeekByDate(date: NSDate) -> NSDate {
        let currentDateComponents = self.calendar.components([.YearForWeekOfYear, .WeekOfYear ], fromDate: date)
        
        return calendar.dateFromComponents(currentDateComponents) ?? NSDate()
    }
    
    static func getLastDayOfWeekByDate(date: NSDate) -> NSDate {
        let startOfWeek = self.getFirstDayOfWeekByDate(date)
        var endOfWeek = self.getDateFor(.NextWeek, date: startOfWeek)
        endOfWeek = self.getDateFor(.PreviousDay, date: endOfWeek)
        
        return endOfWeek
    }
    
}
