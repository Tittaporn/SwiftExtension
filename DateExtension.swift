
//  DateExtension.swift

import Foundation

// MARK: - Date
extension Date {
    var aMonthBeforeFromToday: Date {
        return Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
    }
    
    var tenDaysAgo: Date {
        return Calendar.current.date(byAdding: .day, value: -10, to: Date()) ?? Date()
    }
    
    var fiftyYearsFromToday: Date {
        return Calendar.current.date(byAdding: .year, value: +50, to: Date()) ?? Date()
    }
    
    var eighteenYearsAgo: Date {
        return Calendar.current.date(byAdding: .year, value: -18, to: Date()) ?? Date()
    }
    
    var ninetyYearsAgo: Date {
        return Calendar.current.date(byAdding: .year, value: -90, to: Date()) ?? Date()
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var strApiTime: String {
        return self.changeToCDTsystemTimeZone()?.toString(format: .fullNumericTimestamp) ?? ""
    }
    
    enum DateFormatType: String {
        case fullNumericMDYNoTimestamp = "MM/dd/yyyy"
        case fullNumericTimestamp = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        case timestampWithAMorPM = "hh:mm:ss a"
        case monthDayYearWithTimestampForId = "MM/dd/yyyy hh:mm:ss a"
    }
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    func differentInDays(from: Date) -> Int? {
        return Calendar.current.dateComponents([.day], from: self, to: from).day
    }
    
    func toString(format: DateFormatType) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter.string(from: self)
    }
    
    func changeToCDTsystemTimeZone() -> Date? {
        var timeInterval: TimeInterval
        var nReturnDate: Date
        let sourceOffset = TimeZone.current.secondsFromGMT(for: self)
        guard let systemTimeZone = TimeZone(abbreviation: "CDT") else  {return nil}
        let destinationOffset = systemTimeZone.secondsFromGMT(for: self)
        timeInterval = TimeInterval(destinationOffset - sourceOffset)
        nReturnDate = Date(timeInterval: timeInterval, since: self)
        return  nReturnDate
    }
    
    func convertToSpecificTimeZone(initTimeZone: TimeZone, toTimeZone: String) -> Date {
        guard let timeZone = TimeZone(abbreviation: toTimeZone) else {return Date()}
        let delta = TimeInterval(timeZone.secondsFromGMT(for: self) - initTimeZone.secondsFromGMT(for: self))
        return addingTimeInterval(delta)
    }
    
    func to(timeZone outputTimeZone: TimeZone, from inputTimeZone: TimeZone) -> Date {
        let delta = TimeInterval(outputTimeZone.secondsFromGMT(for: self) - inputTimeZone.secondsFromGMT(for: self))
        return addingTimeInterval(delta)
    }
    
    func addYears(numberOfYears: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: numberOfYears, to: self) ?? Date()
    }
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
    
    func utcDateToLocalDateInString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm:ss a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let date = self.toString(format: .monthDayYearWithTimestampForId)
        if let dt = dateFormatter.date(from: date) {
            dateFormatter.locale = Locale.current
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "MM/dd/yyyy hh:mm:ss a"
            return dateFormatter.string(from: dt)
        } else {
            return "Unknown date"
        }
    }
    
    func utcDateToLocalDateInDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm:ss a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let date = self.toString(format: .monthDayYearWithTimestampForId)
        if let dt = dateFormatter.date(from: date) {
            dateFormatter.locale = Locale.current
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "MM/dd/yyyy hh:mm:ss a"
            
            let strDate =  dateFormatter.string(from: dt)
            return strDate.toDate()
        } else {
            return nil
        }
    }
}
