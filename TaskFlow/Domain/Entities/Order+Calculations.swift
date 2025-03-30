//
//  Order+Calculations.swift.swift
//  TaskFlow
//
//  Created by alexandergaranin on 29.03.2025.
//

import Foundation

private enum CalcConstants {
    enum Tax {
        static let selfEmployedRate = 0.04
        
    }
    
    enum Time {
        static let secInHour = 3600.0
        static let minInHour = 3600.0
    }
}


extension Order {
    /// Общая сумма за все проведенные занятия
    var totalSessionsCost: Double {
        guard let schedules = schedules else { return 0 }
        
        return schedules.reduce(0) { total, schedule in
            guard schedule.completed != nil else { return total }
            guard let start = schedule.start, let finish = schedule.finish else { return total }
            
            let duration = finish.timeIntervalSince(start)
            let hours = duration / CalcConstants.Time.secInHour
            return total + (hours * schedule.cost)
        }
    }
    
    /// Общий перерасход/недоплата времени (в минутах)
    var totalTimeDiscrepancyInMinutes: Int {
        guard let schedules = schedules else { return 0 }
        
        return schedules.reduce(0) { total, schedule in
            guard let completed = schedule.completed else { return total }
            guard let start = schedule.start, let finish = schedule.finish else { return total }
            
            let plannedDuration = finish.timeIntervalSince(start)
            let actualDuration = completed.timeIntervalSince(start)
            let difference = actualDuration - plannedDuration
            
            return total + Int(difference / CalcConstants.Time.minInHour)
        }
    }
    
    /// Чистый доход с учетом налога 4%
    var netIncome: Double {
        return totalPaymentsAmount * (1 - CalcConstants.Tax.selfEmployedRate)
    }
    
    /// Общая сумма всех платежей по заказу
    var totalPaymentsAmount: Double {
        payments?.reduce(0) { $0 + $1.amount } ?? 0
    }
    
    /// Общая сумма налогов
    var totalTax: Double {
        return totalPaymentsAmount * CalcConstants.Tax.selfEmployedRate
    }
    
    /// Завершённые (проведённые) занятия
    var completedMeetingsCount: Int {
        return schedules?.filter { $0.completed != nil }.count ?? 0
    }
    
    /// Всего запланированных занятий
    var totalMeetingsCount: Int {
        return schedules?.count ?? 0
    }
    
    var statisticTaxItems: [StatisticTaxItem]{
        return payments?.reduce(into: [String: (declared: Double, undeclared: Double)]()) { result, payment in
                let key = payment.category?.name ?? "Платежи"
                if payment.declared == true {
                    result[key, default: (0, 0)].declared += payment.amount
                } else if payment.declared == false {
                    result[key, default: (0, 0)].undeclared += payment.amount
                }
            }.map { category, sums in
                StatisticTaxItem(category: category, declared: sums.declared, undeclared: sums.undeclared)
            } ?? []
    }
    
    /// Статистика по проведенным занятиям
    struct OrderStatistics {
        let totalCost: Double
        let totalPayments: Double
        let totalTimeDiscrepancy: String
        let sessionsCount: Int
        let completedSessionsCount: Int
        let netIncome: Double
        let totalTax: Double
    }
    
    /// Полная статистика по занятиям
    var orderTotalStatistics: OrderStatistics {
        return OrderStatistics(
            totalCost: totalSessionsCost,
            totalPayments: totalPaymentsAmount,
            totalTimeDiscrepancy: formattedTotalTimeDiscrepancy,
            sessionsCount: totalMeetingsCount,
            completedSessionsCount: completedMeetingsCount,
            netIncome: netIncome,
            totalTax: totalTax
        )
    }
}
