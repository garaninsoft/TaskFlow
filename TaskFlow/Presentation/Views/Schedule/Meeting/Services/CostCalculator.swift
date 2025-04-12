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
                var duration = finish.timeIntervalSince(start)
                
                if let minDuration = minBillingDuration {
                    duration = max(duration, minDuration)
                }
                
                let hours = duration / 3600
                return meeting.cost * hours
            }
            return nil
        }
}
