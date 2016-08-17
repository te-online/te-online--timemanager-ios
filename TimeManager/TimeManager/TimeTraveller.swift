//
//  TimeTraveller.swift
//  TimeManager
//
//  Created by Thomas Ebert on 16.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit
import CoreData

class TimeTraveller {
    
    var dataController: AppDelegate! = UIApplication.sharedApplication().delegate as! AppDelegate
    var calendar: NSCalendar = NSCalendar.currentCalendar()
    
    init() {
        calendar.firstWeekday = 2
    }
    
    func todaysRecordedHours() -> Double {
        NSLog("Here we go...")
        // Find all time entries from today and sum up hours
        let today = NSDate()
        return self.recordedHoursForDay(today)
    }
    
    func thisWeeksRecordedHours() -> Double {
        // Determine all days in this week
        let today = NSDate()
        
        let currentDateComponents = self.calendar.components([.YearForWeekOfYear, .WeekOfYear ], fromDate: today)
        
        let startOfWeek = calendar.dateFromComponents(currentDateComponents)
        
        let endOfWeek = startOfWeek!.dateByAddingTimeInterval(60 * 60 * 24 * 7)
        
        return self.recordedHoursBetweenDates(startOfWeek!, end: endOfWeek)
    }
    
    func fiveMostRecentEntries() -> [TimeObject] {
        // Get the five most recent time entries by creation date.
        let request = NSFetchRequest(entityName: "Time")
        
        let createdSort = NSSortDescriptor(key: "created", ascending: true)
        request.sortDescriptors = [createdSort]
        
        let notDeleted = NSPredicate(format: "commit != %@", "deleted")
        request.predicate = notDeleted
        
        request.fetchLimit = 5
        
        let moc = self.dataController.managedObjectContext
        
        do {
            let entries = try moc.executeFetchRequest(request)
            return (entries as! [TimeObject])
        } catch {
            fatalError("Failed to execute fetch request for recent entries: \(error)")
        }
    }
    
    func recordedHoursForWeekInProjectFromDate(date: NSDate, project: ProjectObject) -> [String] {
        let weekDates = self.getWeekDatesFromDate(date)
        
        var values = [String]()
        
        for weekDate in weekDates {
            let hours = self.recordedHoursForDateInProject(weekDate!, project: project)
            if hours > 0 {
                values.append(FormattingHelper.formatHoursAsString(hours))
            } else {
                values.append("-")
            }
        }
        
        return values
    }
    
    func recordedHoursForDateInProject(date: NSDate, project: ProjectObject) -> Double {
        let dayBegin = self.getDayBegin(date)
        let dayEnd = self.getDayEnd(date)
        
        let request = NSFetchRequest(entityName: "Time")
        
        let createdSort = NSSortDescriptor(key: "created", ascending: true)
        request.sortDescriptors = [createdSort]
        
        let forDayAndProject = NSPredicate(format: "(start >= %@) AND (end <= %@) AND (task.project = %@) AND (commit != %@)", dayBegin, dayEnd, project, "deleted")
        request.predicate = forDayAndProject
        
        let moc = self.dataController.managedObjectContext
        
        var hoursCount: Double = 0
        
        do {
            let entries = try moc.executeFetchRequest(request)
            if entries.count > 0 {
                for entry in entries {
                    hoursCount += (entry as! TimeObject).getDurationInHours()
                }
            }
        } catch {
            fatalError("Failed to execute fetch request for hours in project by date: \(error)")
        }
        
        return hoursCount
    }
    
    func recordedHoursBetweenDates(start: NSDate, end: NSDate) -> Double {
        let dayBegin = self.getDayBegin(start)
        let dayEnd = self.getDayEnd(end)
        
        let request = NSFetchRequest(entityName: "Time")
        
        let createdSort = NSSortDescriptor(key: "created", ascending: true)
        request.sortDescriptors = [createdSort]
        
        let forDay = NSPredicate(format: "(start >= %@) AND (end <= %@) AND (commit != %@)", dayBegin, dayEnd, "deleted")
        request.predicate = forDay
        
        let moc = self.dataController.managedObjectContext
        
        var hoursCount: Double = 0
        
        do {
            let entries = try moc.executeFetchRequest(request)
            if entries.count > 0 {
                for entry in entries {
                    hoursCount += (entry as! TimeObject).getDurationInHours()
                }
            }
        } catch {
            fatalError("Failed to execute fetch request for todays hours: \(error)")
        }
        
        return hoursCount
    }
    
    func recordedHoursForDay(day: NSDate) -> Double {
        let dayBegin = self.getDayBegin(day)
        let dayEnd = self.getDayEnd(day)
        
        let request = NSFetchRequest(entityName: "Time")
        
        let createdSort = NSSortDescriptor(key: "created", ascending: true)
        request.sortDescriptors = [createdSort]
        
        let forDay = NSPredicate(format: "(start >= %@) AND (start <= %@) AND (commit != %@)", dayBegin, dayEnd, "deleted")
        request.predicate = forDay
        
        let moc = self.dataController.managedObjectContext
        
        var hoursCount: Double = 0
        
        do {
            let entries = try moc.executeFetchRequest(request)
            if entries.count > 0 {
                for entry in entries {
                    hoursCount += (entry as! TimeObject).getDurationInHours()
                }
            }
        } catch {
            fatalError("Failed to execute fetch request for todays hours: \(error)")
        }
        
        return hoursCount
    }
    
    
    func daysOfCurrentWeek() -> [String] {
        let today = NSDate()
        return self.daysOfWeekFromDate(today)
    }
    
    func daysOfWeekFromDate(date: NSDate) -> [String] {
        let dates = self.getWeekDatesFromDate(date)
        
        var formattedDays: [String] = []
        for date in dates {
            formattedDays.append(FormattingHelper.formatDateWithShortDayAndDate(date!).uppercaseString)
        }
        
        return formattedDays
    }
    
    func getDayBegin(day: NSDate) -> NSDate {
        let dayBeginComponents: NSDateComponents = self.calendar.components([.Day,.Month,.Year], fromDate: day)
        dayBeginComponents.hour = 0
        dayBeginComponents.minute = 0
        dayBeginComponents.second = 0
        
        return self.calendar.dateFromComponents(dayBeginComponents)! ?? NSDate()
    }
    
    func getDayEnd(day: NSDate) -> NSDate {
        let dayEndComponents: NSDateComponents = self.calendar.components([.Day,.Month,.Year], fromDate: day)
        dayEndComponents.hour = 23
        dayEndComponents.minute = 59
        dayEndComponents.second = 59
        
        return self.calendar.dateFromComponents(dayEndComponents)! ?? NSDate()
    }
    
    func getWeekDatesFromDate(date: NSDate) -> [NSDate?] {
        let currentDateComponents = self.calendar.components([.YearForWeekOfYear, .WeekOfYear ], fromDate: date)
        let startOfWeek = calendar.dateFromComponents(currentDateComponents)
        var dates = [startOfWeek]
        for i in 1...6 {
            dates.append(startOfWeek?.dateByAddingTimeInterval(60 * 60 * 24 * Double(i)))
        }
        
        return dates
    }
    
    func getHoursForYearFromDate(date: NSDate) -> Double {
        return 5
        // TODO
    }
    
    func getHoursForMonthFromDate(date: NSDate) -> Double {
        return 5
        // TODO
    }
    
    func getHoursForWeekFromDate(date: NSDate) -> Double {
        return 5
        // TODO
    }
    
    func getWeeksInMonthFromDate(date: NSDate) -> [[NSDate]] {
        return [[NSDate(), NSDate()]]
        // TODO
    }
    
    func getWeekNumberFromDate(date: NSDate) -> Int {
        return 31
        // TODO
    }
    
    func getProjectsOfDay(date: NSDate) -> [ProjectObject] {
        return [ProjectObject()]
        // TODO
    }
    
    func getProjectsOfWeek(date: NSDate) -> [ProjectObject] {
        return [ProjectObject()]
        // TODO
        
        // Create an array of all the times in the week
        // Create a unique set of all the tasks with created times in the week
        // Include the latest creation date in the set for each task
        // sort the set by creation date
        // Only use the first 5 entries
    }
    
}
