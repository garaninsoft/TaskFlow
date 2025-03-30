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
    var declared: Bool = false
    var details: String
    var created: Date?
    // declared: Bool? - по самозанятости задекларированный налог
    //                   или расход, котрый будет проходить по полю category
    
    init(order: Order? = nil, category: PaymentCategory? = nil, amount: Double, declared: Bool, details: String, created: Date? = nil) {
        self.order = order
        self.category = category
        self.amount = amount
        self.declared = declared
        self.details = details
        self.created = created
    }
}

