//
//  Student.swift
//  TaskFlow
//
//  Created by alexandergaranin on 15.01.2025.
//

import Foundation
import SwiftData

@Model
final class Order{
    var student: Student?
    var title: String
    var details: String
    var created: Date
    var schedules: [Schedule]?
    var payments: [Payment]?
    var works: [Work]?
    var persistentId: UUID = UUID()
    
    init(student: Student? = nil, title: String, details: String, created: Date, schedules: [Schedule]? = nil, payments: [Payment]? = nil, works: [Work]? = nil) {
        self.student = student
        self.title = title
        self.details = details
        self.created = created
        self.schedules = schedules
        self.payments = payments
        self.works = works
        self.persistentId = UUID()
    }
    
    var folderName: String {
        "order_\(self.persistentId.uuidString.prefix(8))"
    }
}
