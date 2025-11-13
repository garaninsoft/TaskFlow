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
    var details: String
    var created: Date?
    var closed: Date?
    var orders: [Order]?
//    var contacts: [Contact]?
    var persistentId: UUID = UUID()
    
    init(name: String, contacts: String, details: String, created: Date? = nil, closed: Date? = nil, orders: [Order]? = nil) {
        self.name = name
        self.contacts = contacts
        self.details = details
        self.created = created
        self.closed = closed
        self.orders = orders
        self.persistentId = UUID()
    }
    
    var isClosed: Bool { closed != nil }
    
    var folderName: String {
        "st_\(self.name.generateShortNameWithTranslit())_\(self.persistentId.uuidString.prefix(8))"
    }
    
    var inListName: String {
        "\(name)"
    }
}
