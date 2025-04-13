//
//  Student+Calculations.swift
//  TaskFlow
//
//  Created by alexandergaranin on 30.03.2025.
//

import Foundation

extension Student: StatisticsProtocol {
    /// Общая сумма за все проведенные занятия
    var totalSessionsCost: Double {
        guard let orders = orders else { return 0 }
        return orders.reduce(0){ $0 + $1.totalSessionsCost}
    }
    
    var totalCompletedWorksCost: Double {
        orders?.reduce(0) { $0 + $1.totalCompletedWorksCost } ?? 0
    }
    
    /// Общий перерасход/недоплата времени (в минутах)
    var totalTimeDiscrepancyInMinutes: Int {
        guard let orders = orders else { return 0 }
        return orders.reduce(0) { $0 + $1.totalTimeDiscrepancyInMinutes }
    }
    
    /// Чистый доход с учетом налога 4%
    var netIncome: Double {
        guard let orders = orders else { return 0 }
        return orders.reduce(0) { $0 + $1.netIncome }
    }
    
    /// Общая сумма всех платежей по заказу
    var totalPaymentsAmount: Double {
        guard let orders = orders else { return 0 }
        return orders.reduce(0) { $0 + $1.totalPaymentsAmount }
    }
    
    /// Общая сумма всех платежей по категориям по студенту
    /// Общая сумма приходов по урокам вычисляется по отсутствию категории (PaymentCategory==nil)
    var totalPaymentsAmountbyCategory: [PaymentCategory?: Double] {
        // 1. Собираем все платежи из всех заказов в один массив
        let allPayments = orders?.flatMap { $0.payments ?? [] } ?? []
        
        // 2. Считаем сумму по категориям (включая nil)
        return allPayments.reduce(into: [PaymentCategory?: Double]()) { result, payment in
            result[payment.category] = (result[payment.category] ?? 0) + payment.amount
        }
    }
    
    /// Общая сумма налогов
    var totalTax: Double {
        guard let orders = orders else { return 0 }
        return orders.reduce(0) { $0 + $1.totalTax }
    }
    
    /// Завершённые (проведённые) занятия
    var completedMeetingsCount: Int {
        guard let orders = orders else { return 0 }
        return orders.reduce(0) { $0 + $1.completedMeetingsCount }
    }
    
    /// Всего запланированных занятий
    var totalMeetingsCount: Int {
        guard let orders = orders else { return 0 }
        return orders.reduce(0) { $0 + $1.totalMeetingsCount }
    }
    
    var statisticTaxItems: [StatisticTaxItem]{
        guard let orders = orders else { return [] }
        
        let nestedItems: [[StatisticTaxItem]] = orders.compactMap{ $0.statisticTaxItems }
        let flatItems = nestedItems.flatMap { $0 }
        let groupedItems = Dictionary(grouping: flatItems, by: \.category)
        
        let categoryTotals = groupedItems.map { category, items in
            StatisticTaxItem(
                category: category,
                declared: items.reduce(0) { $0 + $1.declared },
                undeclared: items.reduce(0) { $0 + $1.undeclared }
            )
        }
        
        return categoryTotals
    }
    
    /// Полная статистика по занятиям
    var totalStatistics: StatisticTotalItem {
        let totalCost = totalSessionsCost + totalCompletedWorksCost // Это несколько криво. Надо может рефакторнуть в вычисления
        return StatisticTotalItem(
            totalCost: totalCost,
            totalPaymentsMeetings: (totalPaymentsAmountbyCategory[nil] ?? 0) - totalCost,
            totalOtherExpenses: totalPaymentsAmountbyCategory.reduce(0){$0 + ($1.key == nil ? 0 : $1.value)},
            totalPayments: totalPaymentsAmount,
            totalTimeDiscrepancy: formattedTotalTimeDiscrepancy,
            sessionsCount: totalMeetingsCount,
            completedSessionsCount: completedMeetingsCount,
            netIncome: netIncome,
            totalTax: totalTax
        )
    }
}
