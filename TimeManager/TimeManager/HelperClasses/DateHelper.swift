//
//  DateHelper.swift
//  TimeManager
//
//  Created by Thomas Ebert on 22.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

class DateHelper {
    static let calendar = Calendar.current
    
    enum ShiftType {
        case previousDay
        case nextDay
        case previousWeek
        case nextWeek
        case previousMonth
        case nextMonth
        case previousYear
        case nextYear
    }
    
    // Can get you a variety of dates in relation to a given date.
    static func getDateFor(_ dateType: ShiftType, date: Date) -> Date {
        var components = DateComponents()
        
        if(dateType == .previousDay) {
            components.day = -1
        } else if(dateType == .nextDay) {
            components.day = 1
        } else if(dateType == .previousWeek) {
            components.weekOfYear = -1
        } else if(dateType == .nextWeek) {
            components.weekOfYear = 1
        } else if(dateType == .previousMonth) {
            components.month = -1
        } else if(dateType == .nextMonth) {
            components.month = 1
        } else if(dateType == .previousYear) {
            components.year = -1
        }  else if(dateType == .nextYear) {
            components.year = 1
        }
        
        return (self.calendar as NSCalendar).date(byAdding: components, to: date, options: []) ?? Date()
    }
    
    // Gets the very first day of a year.
    static func getFirstDayOfYearByDate(_ date: Date) -> Date {
        let components = (calendar as NSCalendar).components([.year], from: date)
        
        return calendar.date(from: components) ?? Date()
    }
    
    // Gets the very last day of a year.
    static func getLastDayOfYearByDate(_ date: Date) -> Date {
        var components = (calendar as NSCalendar).components([.year], from: date)
        components.year = 1
//        components.day = -1
        
        return (calendar as NSCalendar).date(byAdding: components, to: self.getFirstDayOfYearByDate(date), options: []) ?? Date()
    }
    
    // Gets the very first day of a month.
    static func getFirstDayOfMonthByDate(_ date: Date) -> Date {
        let components = (calendar as NSCalendar).components([.year, .month], from: date)
        
        return calendar.date(from: components) ?? Date()
    }
    
    // Gets the very last day of a month.
    static func getLastDayOfMonthByDate(_ date: Date) -> Date {
        var components = (calendar as NSCalendar).components([.month], from: date)
        components.month = 1
        
        return (calendar as NSCalendar).date(byAdding: components, to: self.getFirstDayOfMonthByDate(date), options: []) ?? Date()
    }
    
    // Gets the number of the current month for comparison. E.g. December -> 12
    static func getMonthNum(_ date: Date) -> Int {
        let components = (calendar as NSCalendar).components([.year, .month], from: date)
        
        return components.month!
    }
    
    // Gets the very first day of a week.
    static func getFirstDayOfWeekByDate(_ date: Date) -> Date {
        let currentDateComponents = (self.calendar as NSCalendar).components([.yearForWeekOfYear, .weekOfYear ], from: date)
        
        return calendar.date(from: currentDateComponents) ?? Date()
    }
    
    // Gets the very last day of a week.
    static func getLastDayOfWeekByDate(_ date: Date) -> Date {
        let startOfWeek = self.getFirstDayOfWeekByDate(date)
        var endOfWeek = self.getDateFor(.nextWeek, date: startOfWeek)
        endOfWeek = self.getDateFor(.previousDay, date: endOfWeek)
        
        return endOfWeek
    }
    
}
