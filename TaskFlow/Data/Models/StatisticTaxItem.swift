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
