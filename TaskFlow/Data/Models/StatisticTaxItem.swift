//
//  StatisticTaxItem.swift
//  TaskFlow
//
//  Created by alexandergaranin on 30.03.2025.
//

import Foundation

/// Учёт проведённых и непроведённых платежей
struct StatisticTaxItem: Identifiable {
    let id = UUID()
    let category: String
    let declared: Double
    let undeclared: Double
}

let sampleItems = [
    StatisticTaxItem(category: "Налоги", declared: 1500, undeclared: 200),
    StatisticTaxItem(category: "Аренда", declared: 30000, undeclared: 0),
    StatisticTaxItem(category: "Услуги", declared: 5000, undeclared: 750),
    
]
