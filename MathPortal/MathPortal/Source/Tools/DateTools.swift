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
