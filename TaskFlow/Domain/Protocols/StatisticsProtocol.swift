//
//  Untitled.swift
//  TaskFlow
//
//  Created by alexandergaranin on 31.03.2025.
//

protocol StatisticsProtocol{
    var totalSessionsCost: Double { get }
    var totalTimeDiscrepancyInMinutes: Int { get }
    var netIncome: Double { get }
    var totalPaymentsAmount: Double { get }
    var totalTax: Double { get }
    var completedMeetingsCount: Int { get }
    var totalMeetingsCount: Int { get }
    var statisticTaxItems: [StatisticTaxItem] { get }
    var totalStatistics: StatisticTotalItem { get }
}
