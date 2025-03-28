//
//  Сategory.swift
//  TaskFlow
//
//  Created by alexandergaranin on 17.03.2025.
//

import Foundation
import SwiftData

@Model
final class PaymentCategory{
    var name: String
    var details: String
    var created: Date
    var payments: [Payment]? = nil
    
    init(name: String, details: String = "", created: Date = Date(), payments: [Payment]? = nil) {
        self.name = name
        self.details = details
        self.created = created
        self.payments = payments
    }
}
