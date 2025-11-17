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
    var contacts2: String?
    var messenger: String?
    var messenger2: String?
    var details: String
    var created: Date?
    var closed: Date?
    var orders: [Order]?
//    var contacts: [Contact]?
    var persistentId: UUID = UUID()
    
    init(name: String, contacts: String = "", contacts2: String? = nil, messenger: String? = nil, messenger2: String? = nil, details: String, created: Date? = nil, closed: Date? = nil, orders: [Order]? = nil) {
        self.name = name
        self.contacts = contacts
        self.contacts2 = contacts2
        self.messenger = messenger
        self.messenger2 = messenger2
        self.details = details
        self.created = created
        self.closed = closed
        self.orders = orders
    }
    
    var isClosed: Bool { closed != nil }
    
    var folderName: String {
        "st_\(self.name.generateShortNameWithTranslit())_\(self.persistentId.uuidString.prefix(3))"
    }
    
    var inListName: String {
        "\(name)"
    }
}
