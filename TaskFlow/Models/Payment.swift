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
    var amount: Double
    var details: String
    var created: Date
    
    init(order: Order? = nil, amount: Double, details: String, created: Date) {
        self.order = order
        self.amount = amount
        self.details = details
        self.created = created
    }
}

