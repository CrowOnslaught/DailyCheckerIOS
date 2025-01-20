//
//  Date.swift
//  DailyChecker
//
//  Created by Jaume García on 18/1/25.
//

import Foundation

extension Date {
    var hour: Int { Calendar.current.component(.hour, from: self) }
    var minute: Int { Calendar.current.component(.minute, from: self) }
    
    func formatDate(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: self)
    }
    
    func isSameDay(of otherDate: Date) -> Bool {
        let components = Calendar.current.dateComponents([.day, .year, .month], from: self)
        let otherDateComponents = Calendar.current.dateComponents([.day, .year, .month], from: otherDate)

        return (components.day == otherDateComponents.day && components.month == otherDateComponents.month && components.year == otherDateComponents.year)
    }
    func isToday() -> Bool {
        return isSameDay(of: Date())
    }
}
