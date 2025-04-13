//
//  LessonCostCalculator.swift
//  TaskFlow
//
//  Created by alexandergaranin on 11.04.2025.
//

import Foundation

struct CostCalculator {
    static func calculate(
        meeting: Schedule,
        minBillingDuration: TimeInterval? = nil) -> Double? {
            if let start = meeting.start, let finish = meeting.finish, let _ = meeting.completed{
                return calc(start: start, finish: finish, cost: meeting.cost)
            }
            return nil
        }
    
    static func calculate(
        start: Date?,
        calcValue finish: Date?,
        cost: Double,
        minBillingDuration: TimeInterval? = nil) -> Double? {
            if let start, let finish{
                return calc(start: start, finish: finish, cost: cost)
            }
            return nil
        }
    
    private static func calc(
        start: Date,
        finish: Date,
        cost: Double,
        minBillingDuration: TimeInterval? = nil
    ) -> Double{
        var duration = finish.timeIntervalSince(start)
        
        if let minDuration = minBillingDuration {
            duration = max(duration, minDuration)
        }
        let hours = duration / 3600
        return cost * hours
    }
}
