//
//  DateTools.swift
//  PetrasWorkspace
//
//  Created by Office on 26/12/18.
//  Copyright © 2018 Petra. All rights reserved.
//


import Foundation

class DateTools {
    
    
    static let hourMinuteDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = NSCalendar.autoupdatingCurrent
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    static let thisYearDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = NSCalendar.autoupdatingCurrent
        formatter.dateFormat = "dd'.'MM'.'"
        return formatter
    }()
    
    static let fullDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = NSCalendar.autoupdatingCurrent
        formatter.dateFormat = "dd'.'MM'.'yyyy"
        return formatter
    }()
    
    static func stringFromDate(date: Date?) -> String {
        guard let date = date else { return "" }
        return fullDateFormatter.string(from: date)
    }
    
    static func dateFromString(string: String?) -> Date? {
        guard let string = string else { return nil }
        return fullDateFormatter.date(from: string)
    }
    
    static func getAgeFromDate(date: Date?) -> Int? {
        guard let date = date else { return nil }
        let components = Calendar.current.dateComponents( [.year], from: date, to: Date())
        return components.year
    }
    
    static func getStringComponent(_ component: Calendar.Component , fromDate date: Date?) -> String? {
        guard let date = date else { return nil }
        let components = NSCalendar.autoupdatingCurrent.dateComponents([.day, .month, .year], from: date)
        var value: Int?
        switch component {
        case .day:  value = components.day
        case .year: value = components.year
        case .month: value = components.month
        default: return nil
        }
        guard let componentValue = value else { return nil }
        return String(componentValue)
    }
    
    static func getDateFromStringComponents(day: String?, month: String?, year: String?) -> Date? {
        guard let day = day, let month = month, let year = year else { return nil }
        let date = day + "." + month + "." + year
        return dateFromString(string: date)
        
    }
    
    static func ageString(ofDate olderDate: Date, relativeTo nowDate: Date = Date()) -> String {
        let duration: TimeInterval =  nowDate.timeIntervalSince(olderDate)
        let secondsAgo: Int = Int(duration)
        let minutesAgo: Int = secondsAgo/60
        let hoursAgo: Int = minutesAgo/60
        
        if minutesAgo < 5 { return "Just now" }
        else if minutesAgo < 60 { return "\(minutesAgo)min ago" }
        else if hoursAgo < 8 { return "\(hoursAgo) hours ago" }
        
        let startDateByRemovingADay = NSCalendar.autoupdatingCurrent.date(byAdding: Calendar.Component.day, value: -1, to: nowDate)
       
        let startComponents = NSCalendar.autoupdatingCurrent.dateComponents([.day, .month, .year], from: nowDate)
        let startByRemovingADayComponents = NSCalendar.autoupdatingCurrent.dateComponents([.day, .month, .year], from: startDateByRemovingADay!)
        let endComponents = NSCalendar.autoupdatingCurrent.dateComponents([.day, .month, .year], from: olderDate)
        
        if  startComponents.year == endComponents.year && startComponents.month == endComponents.month && startComponents.day == endComponents.day {
            return "At \(DateTools.hourMinuteDateFormatter.string(from: olderDate))"
        } else if startByRemovingADayComponents.year == endComponents.year && startByRemovingADayComponents.month == endComponents.month && startByRemovingADayComponents.day == endComponents.day {
            return "Yesterday"
        } else if startComponents.year == endComponents.year {
            return DateTools.thisYearDateFormatter.string(from: olderDate)
        } else {
            return DateTools.fullDateFormatter.string(from: olderDate)
        }
    }

}
