//
//  Student.swift
//  TaskFlow
//
//  Created by alexandergaranin on 15.01.2025.
//

import Foundation
import SwiftData

@Model
final class Student {
    var name: String
    var contacts: String
    var created: Date
    var closed: Date?
    var orders: [Order]?
    
    init(name: String, contacts: String, created: Date, closed: Date? = nil, orders: [Order]? = nil) {
        self.name = name
        self.contacts = contacts
        self.created = created
        self.closed = closed
        self.orders = orders
    }
}
