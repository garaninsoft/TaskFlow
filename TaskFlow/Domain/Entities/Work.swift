//
//  PaidWork.swift
//  TaskFlow
//
//  Created by alexandergaranin on 05.04.2025.
//

import Foundation
import SwiftData

@Model
final class Work{
    var order: Order?
    var created: Date?
    var completed: Date?
    var cost: Double
    var details: String
    
    init(order: Order? = nil, created: Date? = nil, completed: Date? = nil, cost: Double, details: String) {
        self.order = order
        self.created = created
        self.completed = completed
        self.cost = cost
        self.details = details
    }
}
