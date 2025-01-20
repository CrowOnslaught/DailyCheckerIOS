//
//  DateComponents.swift
//  DailyChecker
//
//  Created by Jaume García on 18/1/25.
//

import Foundation

extension DateComponents: @retroactive Comparable {
    public static func < (lhs: DateComponents, rhs: DateComponents) -> Bool {
        let now = Date()
        let calendar = Calendar.current
        return calendar.date(byAdding: lhs, to: now)! < calendar.date(byAdding: rhs, to: now)!
    }
    
    public static func == (lhs: DateComponents, rhs: DateComponents) -> Bool {
        let now = Date()
        let calendar = Calendar.current
        return calendar.date(byAdding: lhs, to: now)!.isSameDay(of: calendar.date(byAdding: rhs, to: now)!)
    }
    
    public func isSameDay(of date: Date) -> Bool {
        let now = Date()
        let calendar = Calendar.current
        return calendar.date(byAdding: self, to: now)!.isSameDay(of: date)
    }
}

