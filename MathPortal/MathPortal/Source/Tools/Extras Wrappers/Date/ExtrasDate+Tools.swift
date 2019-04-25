import UIKit

private enum WeekDayStart: Int {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
}


extension DateExtras {
    
    class _DefaultCalendar {
        
        class func calendar() -> Calendar {
            return Calendar.autoupdatingCurrent
        }
        
        // MARK: - Date helper methods
        
        class func beginningOfDay(_ date: Date) -> Date {
            return calendar().startOfDay(for: date)
        }
        
        class func nowTime() -> Date {
            return Date(timeIntervalSince1970: Date().timeIntervalSince(beginningOfDay(Date())))
        }
        
        class func startOfMonthForDate(_ date: Date) -> Date {
            
            let currentCalendar = calendar()
            let currentDateComponents = (currentCalendar as NSCalendar).components([.year, .month], from: date)
            if let startOfMonth = currentCalendar.date(from: currentDateComponents) {
                return startOfMonth
            }
            
            return date
        }
        
        class func startOfHourForDate(_ date: Date) -> Date {
            
            let currentCalendar = calendar()
            let currentDateComponents = (currentCalendar as NSCalendar).components([.year, .month, .day, .hour], from: date)
            if let startOfHour = currentCalendar.date(from: currentDateComponents) {
                return startOfHour
            }
            
            return date
        }
        
        class func dateByMergingDate(_ date: Date, withTime time: Date) -> Date? {
            let currentCalendar = calendar()
            
            let timeComponents = (currentCalendar as NSCalendar).components([.hour, .minute], from: time)
            return (currentCalendar as NSCalendar).date(byAdding: timeComponents, to: date, options: NSCalendar.Options(rawValue: 0))
        }
        
        class func extractDateFromDate(_ date: Date?) -> Date? {
            guard let date = date else {
                return nil
            }
            
            let currentCalendar = calendar()
            
            let dateComponents = (currentCalendar as NSCalendar).components([.year, .month, .day], from: date)
            return currentCalendar.date(from: dateComponents)
        }
        
        class func endOfMonthForDate(_ date: Date) -> Date {
            
            let currentCalendar = calendar()
            let plusOneMonthDate = addMonths(value: 1, date: date)
            let plusOneMonthDateComponents = (currentCalendar as NSCalendar).components([.year, .month], from: plusOneMonthDate)
            
            if let endOfMonth = currentCalendar.date(from: plusOneMonthDateComponents)?.addingTimeInterval(-1) {
                return endOfMonth
            }
            
            return date
        }
        
        class func isToday(_ date: Date) -> Bool {
            let currentCalendar = calendar()
            
            let todayDateComponents = (currentCalendar as NSCalendar).components([.year, .month, .day], from: Date())
            let otherDateComponents = (currentCalendar as NSCalendar).components([.year, .month, .day], from: date)
            
            let todayDate = currentCalendar.date(from: todayDateComponents)
            let otherDate = currentCalendar.date(from: otherDateComponents)
            
            if let todayDate = todayDate, let otherDate = otherDate {
                return todayDate.compare(otherDate) == .orderedSame
            }
            
            return false
        }
        
        class func wasYesterday(_ date: Date) -> Bool {
            let currentCalendar = calendar()
            
            let yesterday = addDays(value: -1, date: Date())
            
            let yesterdayDateComponents = (currentCalendar as NSCalendar).components([.year, .month, .day], from: yesterday)
            let otherDateComponents = (currentCalendar as NSCalendar).components([.year, .month, .day], from: date)
            
            let yesterdayDate = currentCalendar.date(from: yesterdayDateComponents)
            let otherDate = currentCalendar.date(from: otherDateComponents)
            
            if let yesterdayDate = yesterdayDate, let otherDate = otherDate {
                return yesterdayDate.compare(otherDate) == .orderedSame
            }
            
            return false
        }
        
        class func numberOfDaysBetweenEarlierDate(_ earlierDate: Date, laterDate: Date) -> Int {
            let usedCalendar = calendar()
            
            // Replace the hour (time) of both dates with 00:00
            let date1 = usedCalendar.startOfDay(for: earlierDate)
            let date2 = usedCalendar.startOfDay(for: laterDate)
            
            let flags = NSCalendar.Unit.day
            let components = (usedCalendar as NSCalendar).components(flags, from: date1, to: date2, options: [])
            
            // Return number of days
            return components.day!
        }
        
        class func isCurrentWeek(_ date: Date) -> Bool {
            let currentCalendar = calendar()
            return (currentCalendar as NSCalendar).compare(Date(), to: date, toUnitGranularity: .weekOfYear) == .orderedSame
        }
        
        class func isNextWeek(_ date: Date) -> Bool {
            let currentCalendar = calendar()
            guard let nextWeekDate = (Calendar.current as NSCalendar).date(byAdding: .weekOfYear, value: 1, to: Date(), options: []) else {
                return false
            }
            
            return (currentCalendar as NSCalendar).compare(nextWeekDate, to: date, toUnitGranularity: .weekOfYear) == .orderedSame
        }
        
        class func wasPreviousWeek(_ date: Date) -> Bool {
            let currentCalendar = calendar()
            guard let previousWeekDate = (Calendar.current as NSCalendar).date(byAdding: .weekOfYear, value: -1, to: Date(), options: []) else {
                return false
            }
            
            return (currentCalendar as NSCalendar).compare(previousWeekDate, to: date, toUnitGranularity: .weekOfYear) == .orderedSame
        }
        
        class func dateWithTimeComponents(_ date: Date?) -> Date? {
            guard let date = date else {
                return nil
            }
            
            let currentCalendar = calendar()
            return currentCalendar.date(from: (currentCalendar as NSCalendar).components([.hour, .minute, .second], from: date))
        }
        
        class func dateWithoutTimestamp(_ date: Date?) -> Date? {
            guard let date = date else {
                return nil
            }
            
            let currentCalendar = calendar()
            return currentCalendar.date(from: (currentCalendar as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: date))
        }
        
        class func compareTime(_ firstDate: Date, secondDate: Date) -> ComparisonResult {
            guard let convertedFirstDate = dateWithTimeComponents(firstDate), let convertedSecondDate = dateWithTimeComponents(secondDate) else {
                return .orderedSame
            }
            
            return convertedFirstDate.compare(convertedSecondDate)
        }
        
        class func timeIsBetween(_ time: Date?, timeBefore: Date?, timeAfter: Date?) -> Bool {
            guard let timeComponents = dateWithTimeComponents(time), let beforeComponents = dateWithTimeComponents(timeBefore), let afterComponents = dateWithTimeComponents(timeAfter) else {
                return false
            }
            
            return compareDate(beforeComponents, withDate: timeComponents) != .orderedDescending && compareDate(timeComponents, withDate: afterComponents) != .orderedDescending
        }
        
        class func compareDate(_ firstDate: Date, withDate secondDate: Date) -> ComparisonResult {
            guard let convertedFirstDate = dateWithoutTimestamp(firstDate), let convertedSecondDate = dateWithoutTimestamp(secondDate) else {
                return .orderedSame
            }
            
            return convertedFirstDate.compare(convertedSecondDate)
        }
        
        class func intervalBetween(firstDate: Date?, secondDate: Date?) -> TimeInterval? {
            guard let convertedFirstDate = dateWithoutTimestamp(firstDate), let convertedSecondDate = dateWithoutTimestamp(secondDate) else {
                return nil
            }
            
            return convertedFirstDate.timeIntervalSince(convertedSecondDate)
        }
        
        class func compareExtractedDate(_ firstDate: Date?, withDate secondDate: Date?) -> ComparisonResult {
            guard let convertedFirstDate = extractDateFromDate(firstDate), let convertedSecondDate = extractDateFromDate(secondDate) else {
                return .orderedSame
            }
            
            return convertedFirstDate.compare(convertedSecondDate)
        }
        
        class func beginningOfYear(date: Date) -> Date {
            return calendar().date(from: calendar().dateComponents([.year], from: date)) ?? date
        }
        
        class func beginningOfMonth(date: Date) -> Date {
            return calendar().date(from: calendar().dateComponents([.year, .month], from: date)) ?? date
        }
        
        class func beginningOfWeek(date: Date) -> Date {
            return calendar().date(from: calendar().dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)) ?? date
        }
        
        class func addMonths(value: Int, date: Date) -> Date {
            return calendar().date(byAdding: .month, value: value, to: date) ?? date
        }
        
        class func addWeeks(value: Int, date: Date) -> Date {
            return calendar().date(byAdding: .weekOfYear, value: value, to: date) ?? date
        }
        
        class func addDays(value: Int, date: Date) -> Date {
            return calendar().date(byAdding: .day, value: value, to: date) ?? date
        }
        
        class func monthOfDate(date: Date) -> Int {
            return calendar().component(.month, from: date)
        }
        
    }
    
    class Device: _DefaultCalendar {
        
    }
    
    class UTC: _DefaultCalendar {
        fileprivate static var _calendar: Calendar?
        
        override class func calendar() -> Calendar {
            if let calendar = _calendar {
                return calendar
            } else {
                var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
                calendar.firstWeekday = WeekDayStart.monday.rawValue // Sets the first day of week to Monday
                
                if let zone = TimeZone(abbreviation: "UTC") {
                    calendar.timeZone = zone
                    _calendar = calendar
                    return calendar
                } else {
                    print("Could not create an UTC date")
                    return Calendar.autoupdatingCurrent
                }
            }
        }
        
        class func dateFromTime(hours: Int, minutes: Int) -> Date {
            return Date(timeIntervalSince1970: TimeInterval((60*hours + minutes)*60))
        }
        
        fileprivate static var _timeStringFormatter: DateFormatter?
        fileprivate static var _hourStringFormatter: DateFormatter?
        fileprivate static var _dayMonthStringFormatter: DateFormatter?
        
        static var hourStringFormatter: DateFormatter {
            set {
                _hourStringFormatter = hourStringFormatter
            }
            
            get {
                if _hourStringFormatter == nil {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "H"
                    formatter.calendar = calendar()
                    formatter.timeZone = formatter.calendar.timeZone
                    _hourStringFormatter = formatter
                }
                
                return _hourStringFormatter!
            }
        }
        
        class func hourStringFromDate(_ date: Date?) -> String {
            if let date = date {
                return hourStringFormatter.string(from: date)
            } else {
                return ""
            }
        }
    }
    
    
}

extension DateExtras._DefaultCalendar {
    
    enum FormatterType {
        case shortTimeFormatter, shortDateWithoutYearFormatter, shortDateFormatter
        case dayDateFormatter, shortDayDateFormatter, monthDateFormatter, dayOfMonthDateFormatter, shortDayOfMonthDateFormatter, shortHourOfDayDateFormatter
        case apiDateFormatter, apiTimeFormatter, apiDateWithTimezoneFormatter, shortApiDateFormatter
        case dayAndFullMonthNameFormatter, monthNameFormatter, shortDayNameFormatter, dayNameFormatter
        
        fileprivate func formatter() -> (formatter: DateFormatter, applyTimeZone: Bool) {
            switch self {
            case .shortTimeFormatter: return (DateExtras._DefaultCalendar.shortTimeFormatter, true)
            case .shortDateWithoutYearFormatter: return (DateExtras._DefaultCalendar.shortDateWithoutYearFormatter, true)
            case .shortDateFormatter: return (DateExtras._DefaultCalendar.shortDateFormatter, true)
                
            case .dayDateFormatter: return (DateExtras._DefaultCalendar.dayDateFormatter, true)
            case .shortDayDateFormatter: return (DateExtras._DefaultCalendar.shortDayDateFormatter, true)
            case .monthDateFormatter: return (DateExtras._DefaultCalendar.monthDateFormatter, true)
            case .dayOfMonthDateFormatter: return (DateExtras._DefaultCalendar.dayOfMonthDateFormatter, true)
            case .shortDayOfMonthDateFormatter: return (DateExtras._DefaultCalendar.shortDayOfMonthDateFormatter, true)
            case .shortHourOfDayDateFormatter: return (DateExtras._DefaultCalendar.shortHourOfDayDateFormatter, true)
                
            case .apiDateFormatter: return (DateExtras._DefaultCalendar.apiDateFormatter, true)
            case .apiTimeFormatter: return (DateExtras._DefaultCalendar.apiTimeFormatter, true)
            case .apiDateWithTimezoneFormatter: return (DateExtras._DefaultCalendar.apiDateWithTimezoneFormatter, false)
            case .shortApiDateFormatter: return (DateExtras._DefaultCalendar.shortApiDateFormatter, true)
                
            case .dayAndFullMonthNameFormatter: return (DateExtras._DefaultCalendar.dayAndFullMonthNameFormatter, true)
            case .monthNameFormatter: return (DateExtras._DefaultCalendar.monthNameFormatter, true)
            case .shortDayNameFormatter: return (DateExtras._DefaultCalendar.shortDayNameFormatter, true)
            case .dayNameFormatter: return (DateExtras._DefaultCalendar.dayNameFormatter, true)
            }
        }
    }
    
    class func formatter(_ type: FormatterType) -> DateFormatter {
        let (formatter, applyTimeZone) = type.formatter()
        
        let formatterCalendar = calendar()
        formatter.calendar = formatterCalendar
        
        if applyTimeZone {
            formatter.timeZone = formatterCalendar.timeZone
        }
        
        return formatter
    }
    
    fileprivate static let shortTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    fileprivate static let dayAndFullMonthNameFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "dMMMM", options: 0, locale: Locale.current)
        return formatter
    }()
    
    fileprivate static let monthNameFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMMM", options: 0, locale: Locale.current)
        return formatter
    }()
    
    fileprivate static let shortDayNameFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEEE", options: 0, locale: Locale.current)
        return formatter
    }()
    
    fileprivate static let dayNameFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEE", options: 0, locale: Locale.current)
        return formatter
    }()
    
    fileprivate static let shortDateWithoutYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "Md", options: 0, locale: Locale.current)
        return formatter
    }()
    
    fileprivate static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "dMyyyy", options: 0, locale: Locale.current)
        return formatter
    }()
    
    fileprivate static let dayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    
    fileprivate static let shortDayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()
    
    fileprivate static let monthDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter
    }()
    
    fileprivate static let dayOfMonthDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
    }()
    
    fileprivate static let shortDayOfMonthDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    fileprivate static let shortHourOfDayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "H"
        return formatter
    }()
    
    fileprivate static let apiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss"
        return formatter
    }()
    
    fileprivate static let apiTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH':'mm"
        return formatter
    }()
    
    fileprivate static let apiDateWithTimezoneFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        return formatter
    }()
    
    fileprivate static let shortApiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd"
        return formatter
    }()
    
    // MARK: - Helper methods
    
    class func dayNameStringForDate(_ date: Date) -> String {
        return formatter(.dayDateFormatter).string(from: date).capitalized
    }
    
    class func shortDayNameWithDateString(for date: Date) -> String {
        let dayString = formatter(.shortDayDateFormatter).string(from: date)
        let dateString = formatter(.shortDateWithoutYearFormatter).string(from: date)
        return dayString + ", " + dateString
    }
    
    class func dateAgoStringFromDate(_ date: Date, includingDay: Bool = false, includingHour: Bool = false, includingYear: Bool = true) -> String {
        var dateString = ""
        if isToday(date) {
            dateString = "Today"
            
        } else if wasYesterday(date) {
            dateString = "Yesterday"
            
        } else {
            if includingDay {
                dateString = dayNameStringForDate(date)
            }
            
            let string = includingYear ? formatter(.shortDateFormatter).string(from: date) : formatter(.shortDateWithoutYearFormatter).string(from: date)
            
            if dateString.isEmpty {
                dateString = string
            } else {
                dateString.append(", \(string)")
            }
        }
        
        if includingHour {
            dateString.append(", \(formatter(.shortTimeFormatter).string(from: date))")
        }
        
        return dateString
    }
}

