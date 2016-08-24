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
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    init() {
        calendar.firstWeekday = (self.defaults.integerForKey("startWeekWith") == 0) ? 2 : self.defaults.integerForKey("startWeekWith") - 1
    }
    
    // The sum of the hours, recorded on this day.
    func todaysRecordedHours() -> Double {
        let today = NSDate()
        
        return self.recordedHoursForDay(today)
    }
    
    // The sum of the hours, recorded in this week.
    func thisWeeksRecordedHours() -> Double {
        let today = NSDate()
        
        return self.recordedHoursForWeekFromDate(today)
    }
    
    // The sum of the hours recorded in the given week.
    func recordedHoursForWeekFromDate(date: NSDate) -> Double {
        let currentDateComponents = self.calendar.components([.YearForWeekOfYear, .WeekOfYear ], fromDate: date)
        
        let startOfWeek = calendar.dateFromComponents(currentDateComponents)
        let endOfWeek = startOfWeek!.dateByAddingTimeInterval(60 * 60 * 24 * 7)
        
        return self.recordedHoursBetweenDates(startOfWeek!, end: endOfWeek)
    }
    
    // The five most recent tasks in a week.
    func fiveMostRecentTasksInWeekByDate(date: NSDate) -> [TaskObject] {
        // Create an array of all the times in the week
        let weekDates = self.getWeekDatesFromDate(date)
        let startOfWeek = self.getDayBegin(weekDates[0] ?? NSDate())
        let endOfWeek = self.getDayEnd(weekDates[6] ?? NSDate())
        
        let request = NSFetchRequest(entityName: "Time")
        
        let createdSort = NSSortDescriptor(key: "created", ascending: true)
        request.sortDescriptors = [createdSort]
        
        let forWeek = NSPredicate(format: "(start > %@) AND (end <= %@)", startOfWeek, endOfWeek)
        request.predicate = forWeek
        
        do {
            let times = try self.dataController.managedObjectContext.executeFetchRequest(request)
            // Create a unique set of all the tasks with created times in the week
            var tasks: [TaskObject] = []
            // Get all tasks.
            for time in times {
                tasks.append((time as! TimeObject).task!)
            }
            // Make them unique
            var uniqueTasks = Array(Set(tasks))
            // sort the set by total hours
            uniqueTasks = uniqueTasks.sort({ ($0 as TaskObject).getTotalHours() > ($1 as TaskObject).getTotalHours() })
            // Only use the first 5 entries
            return Array(uniqueTasks.prefix(5))
        } catch {
            fatalError("Failed to execute fetch request recent tasks for week: \(error)")
        }
    }
    
    /*
     *  Returns an array of the hours of a project in a specific week, specified by a date in this week.
     *  e.g. ["5 hrs.", "12 hrs", "-", "1.25 hrs.", "6 hrs.", "-", "-"]
     *
    */
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
    
    // The sum of the recorded hours for a project on a given date.
    func recordedHoursForDateInProject(date: NSDate, project: ProjectObject) -> Double {
        let dayBegin = self.getDayBegin(date)
        let dayEnd = self.getDayEnd(date)
        
        let request = NSFetchRequest(entityName: "Time")
        
        let createdSort = NSSortDescriptor(key: "created", ascending: true)
        request.sortDescriptors = [createdSort]
        
        let forDayAndProject = NSPredicate(format: "(start >= %@) AND (end <= %@) AND (task.project = %@) AND ((commit == nil) OR (commit != %@))", dayBegin, dayEnd, project, "deleted")
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
    
    /*
     *  Returns an array of the hours of a task in a specific week, specified by a date in this week.
     *  e.g. ["5 hrs.", "12 hrs", "-", "1.25 hrs.", "6 hrs.", "-", "-"]
     *
     */
    func recordedHoursForWeekInTaskFromDate(date: NSDate, task: TaskObject) -> [String] {
        let weekDates = self.getWeekDatesFromDate(date)
        
        var values = [String]()
        
        for weekDate in weekDates {
            let hours = self.recordedHoursForDateInTask(weekDate!, task: task)
            if hours > 0 {
                values.append(FormattingHelper.formatHoursAsString(hours))
            } else {
                values.append("-")
            }
        }
        
        return values
    }
    
    // The sum of the recorded hours for a task on a given date.
    func recordedHoursForDateInTask(date: NSDate, task: TaskObject) -> Double {
        let dayBegin = self.getDayBegin(date)
        let dayEnd = self.getDayEnd(date)
        
        let request = NSFetchRequest(entityName: "Time")
        
        let createdSort = NSSortDescriptor(key: "created", ascending: true)
        request.sortDescriptors = [createdSort]
        
        let forDayAndProject = NSPredicate(format: "(start >= %@) AND (end <= %@) AND (task = %@) AND ((commit == nil) OR (commit != %@))", dayBegin, dayEnd, task, "deleted")
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

    // The hours that were recorded between two dates.
    func recordedHoursBetweenDates(start: NSDate, end: NSDate) -> Double {
        let dayBegin = self.getDayBegin(start)
        let dayEnd = self.getDayEnd(end)
        
        let request = NSFetchRequest(entityName: "Time")
        
        let createdSort = NSSortDescriptor(key: "created", ascending: true)
        request.sortDescriptors = [createdSort]
        
        let forDay = NSPredicate(format: "(start >= %@) AND (end < %@) AND ((commit == nil) OR (commit != %@))", dayBegin, dayEnd, "deleted")
        request.predicate = forDay
        
        var hoursCount: Double = 0
        
        do {
            let entries = try self.dataController.managedObjectContext.executeFetchRequest(request)
            if entries.count > 0 {
                for entry in entries {
                    hoursCount += (entry as! TimeObject).getDurationInHours()
                }
            }
        } catch {
            fatalError("Failed to execute fetch request for today's hours: \(error)")
        }
        
        return hoursCount
    }
    
    // The hours that were recorded on a specific day.
    func recordedHoursForDay(day: NSDate) -> Double {
        let dayBegin = self.getDayBegin(day)
        let dayEnd = self.getDayEnd(day)
        
        let request = NSFetchRequest(entityName: "Time")
        
        let createdSort = NSSortDescriptor(key: "created", ascending: true)
        request.sortDescriptors = [createdSort]
        
        let forDay = NSPredicate(format: "(start >= %@) AND (start <= %@) AND ((commit == nil) OR (commit != %@))", dayBegin, dayEnd, "deleted")
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
    
    // Alias for daysOfWeekFromDate for today.
    func daysOfCurrentWeek() -> [String] {
        let today = NSDate()
        return self.daysOfWeekFromDate(today)
    }
    
    // An array of day descriptions for the collection view header.
    // E.g. ["Mo 1.8.", "Tu 2.8.", "Th 3.8.", ... ]
    func daysOfWeekFromDate(date: NSDate) -> [String] {
        let dates = self.getWeekDatesFromDate(date)
        
        var formattedDays: [String] = []
        for date in dates {
            formattedDays.append(FormattingHelper.dateFormat(.ShortDaynameDayMonth, date: date!).uppercaseString)
        }
        
        return formattedDays
    }
    
    // Get the beginning of a given day.
    func getDayBegin(day: NSDate) -> NSDate {
        let dayBeginComponents: NSDateComponents = self.calendar.components([.Day,.Month,.Year], fromDate: day)
        dayBeginComponents.hour = 0
        dayBeginComponents.minute = 0
        dayBeginComponents.second = 0
        
        return self.calendar.dateFromComponents(dayBeginComponents)! ?? NSDate()
    }
    
    // Get the end of a given day.
    func getDayEnd(day: NSDate) -> NSDate {
        let dayEndComponents: NSDateComponents = self.calendar.components([.Day,.Month,.Year], fromDate: day)
        dayEndComponents.hour = 23
        dayEndComponents.minute = 59
        dayEndComponents.second = 59
        
        return self.calendar.dateFromComponents(dayEndComponents)! ?? NSDate()
    }
    
    // Get the dates of all days in a specific week.
    func getWeekDatesFromDate(date: NSDate) -> [NSDate?] {
        let currentDateComponents = self.calendar.components([.YearForWeekOfYear, .WeekOfYear ], fromDate: date)
        let startOfWeek = calendar.dateFromComponents(currentDateComponents)
        var dates = [startOfWeek]
        for i in 1...6 {
            dates.append(startOfWeek?.dateByAddingTimeInterval(60 * 60 * 24 * Double(i)))
        }
        
        return dates
    }
    
    // Get the hours for a year from a date in this year.
    func getHoursForYearFromDate(date: NSDate) -> Double {
        // Determine the first day of this year
        let firstDayOfYear = DateHelper.getFirstDayOfYearByDate(date)
        // Determine the last day of this year
        let lastDayOfYear = DateHelper.getLastDayOfYearByDate(date)
        // Get the hours between the date (recordedHoursBetweenDates)
        
        return self.recordedHoursBetweenDates(firstDayOfYear, end: lastDayOfYear)
    }
    
    // Get the hours for a month from a date in this month.
    func getHoursForMonthFromDate(date: NSDate) -> Double {
        // Determine the first day of this month
        let firstDayOfMonth = DateHelper.getFirstDayOfMonthByDate(date)
        // Determine the last day of this month
        let lastDayOfMonth = DateHelper.getLastDayOfMonthByDate(date)
        // Get the hours between the date (recordedHoursBetweenDates)
        
        return self.recordedHoursBetweenDates(firstDayOfMonth, end: lastDayOfMonth)
    }
    
    // Alias for recordedHoursForWeekFromDate
    func getHoursForWeekFromDate(date: NSDate) -> Double {
        return self.recordedHoursForWeekFromDate(date)
    }
    
    // Get the hours for a week from a date in this week.
    func getHoursForMonthByDate(date: NSDate) -> [Double] {
        // Go to the beginning of the month.
        let firstDay = DateHelper.getFirstDayOfMonthByDate(date)
        // Add the hours of this week to the array.
        var results: [Double] = []
        results.append(self.getHoursForWeekFromDate(firstDay))
        var currentWeekPointer = firstDay
        let thisMonth = DateHelper.getMonthNum(currentWeekPointer)
        // Do this while the current date's month is the same as the starting week's month.
        while DateHelper.getMonthNum(DateHelper.getDateFor(.NextWeek, date: currentWeekPointer)) == thisMonth {
            // Add one month to the current date.
            currentWeekPointer = DateHelper.getDateFor(.NextWeek, date: currentWeekPointer)
            // Add the hours of the current month to the array.
            results.append(self.getHoursForWeekFromDate(currentWeekPointer))
        }
        
        // Return the array.
        return results
    }
    
    // ["WEEK 31 (1.8. – 7.8.)", "WEEK 32 (1.8. – 7.8.)", "WEEK 33 (1.8. – 7.8.)", "WEEK 34 (15.8. – 17.8.)"]
    func getWeeksForMonthByDate(date: NSDate) -> [String] {
        // Go to the beginning of the month.
        let firstDay = DateHelper.getFirstDayOfMonthByDate(date)
        // Add the hours of this week to the array.
        var results: [String] = []
        results.append(FormattingHelper.dateFormat(.WeekAndDaySpan, date: firstDay).uppercaseString)
        var currentWeekPointer = firstDay
        let thisMonth = DateHelper.getMonthNum(currentWeekPointer)
        // Do this while the current date's month is the same as the starting week's month.
        while DateHelper.getMonthNum(DateHelper.getDateFor(.NextWeek, date: currentWeekPointer)) == thisMonth {
            // Add one month to the current date.
            currentWeekPointer = DateHelper.getDateFor(.NextWeek, date: currentWeekPointer)
            // Add the hours of the current month to the array.
            results.append(FormattingHelper.dateFormat(.WeekAndDaySpan, date: currentWeekPointer).uppercaseString)
        }
        
        return results
    }
    
    // [100, 120, 130, 20, 50, 60, 75, 230, 45, 98, 12, 25]
    func getHoursForYearByDate(date: NSDate) -> [Double] {
        // Go to the beginning of the year.
        let firstDay = DateHelper.getFirstDayOfYearByDate(date)
        // Add the hours of this month to the array.
        var results: [Double] = []
        results.append(self.getHoursForMonthFromDate(firstDay))
        var currentMonthPointer = firstDay
        // Do this for 11 months left.
        for _ in 1...11 {
            // Add one month to the current date.
            currentMonthPointer = DateHelper.getDateFor(.NextMonth, date: currentMonthPointer)
            // Add the hours of the current month to the array.
            results.append(self.getHoursForMonthFromDate(currentMonthPointer))
        }
        
        // Return the array.
        return results
    }
    
    /*
     *  Returns an array of the hours in a specific week, specified by a date in this week.
     *  e.g. [5, 8.5, 2.75, 7.5, 7, 0, 0]
     *
     */
    func recordedHoursForWeekByDate(date: NSDate) -> [Double] {
        let weekDates = self.getWeekDatesFromDate(date)
        
        var values = [Double]()
        
        for weekDate in weekDates {
            values.append(self.recordedHoursForDay(weekDate!))
        }
        
        return values
    }
    
    // [1.75, 3, 2, 2, 1.25]
    func recordedHoursInProjectsByDate(date: NSDate) -> [Double] {
        // Do the same as in tasks, but for projects and without limit and return raw values.
        let projects = self.ProjectsByDate(date)
        var hours: [Double] = []
        for project in projects {
            hours.append(self.recordedHoursForDateInProject(date, project: project))
        }
        
        return hours
    }
    
    // Return a list of projects that have been worked on, on a secific day.
    func ProjectsByDate(date: NSDate) -> [ProjectObject] {
        // Create an array of all the times in the week
        let startOfDay = self.getDayBegin(date)
        let endOfDay = self.getDayEnd(date)
        
        let request = NSFetchRequest(entityName: "Time")
        
        let createdSort = NSSortDescriptor(key: "created", ascending: true)
        request.sortDescriptors = [createdSort]
        
        let forDay = NSPredicate(format: "(start >= %@) AND (end < %@)", startOfDay, endOfDay)
        request.predicate = forDay
        
        do {
            let times = try self.dataController.managedObjectContext.executeFetchRequest(request)
            // Create a unique set of all the tasks with created times in the week
            var tasks: [TaskObject] = []
            // Get all tasks.
            for time in times {
                tasks.append((time as! TimeObject).task!)
            }
            // Make them unique
            let uniqueTasks = Array(Set(tasks))
            // Get all projects.
            var projects: [ProjectObject] = []
            for task in uniqueTasks {
                projects.append(task.project!)
            }
            // Make them unique.
            var uniqueProjects = Array(Set(projects))
            // sort the set by total hours
            uniqueProjects = uniqueProjects.sort({ ($0 as ProjectObject).getTotalHours() > ($1 as ProjectObject).getTotalHours() })
            // Only use the first 5 entries
            return uniqueProjects
        } catch {
            fatalError("Failed to execute fetch request recent tasks for week: \(error)")
        }
    }
    
}
