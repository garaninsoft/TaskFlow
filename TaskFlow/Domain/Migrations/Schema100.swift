//
//  PersonMigrations.swift
//  TaskFlow
//
//  Created by alexandergaranin on 16.04.2025.
//

import SwiftData
import Foundation

//// MARK: - Версия 1.0.0
enum Schema100: VersionedSchema {
    static var models: [any PersistentModel.Type] = [
        Payment.self
    ]
    static var versionIdentifier: Schema.Version = .init(1, 0, 0)
    
    @Model
    final class Payment {
        var order: Order?
        var category: PaymentCategory?
        var amount: Double
        var declared: Bool
        var details: String
        var created: Date?
        
        init(order: Order? = nil, category: PaymentCategory? = nil, amount: Double, declared: Bool, details: String, created: Date? = nil) {
            self.order = order
            self.category = category
            self.amount = amount
            self.declared = declared
            self.details = details
            self.created = created
        }
    }

}

