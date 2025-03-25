//
//  Payment.swift
//  TaskFlow
//
//  Created by alexandergaranin on 14.02.2025.
//
import Foundation
import SwiftData

@Model
final class Payment {
    var order: Order?
    var category: PaymentCategory?
    var amount: Double
    var details: String
    var created: Date?
    
    init(order: Order? = nil, category: PaymentCategory? = nil, amount: Double, details: String, created: Date?) {
        self.order = order
        self.category = category
        self.amount = amount
        self.details = details
        self.created = created
    }
}

