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
    var agent: String?
    var commission: Double?
    var feedealine: Date?
    var details: String
    var created: Date
    var schedules: [Schedule]?
    var payments: [Payment]?
    var works: [Work]?
    var persistentId: UUID = UUID()
    
    init(student: Student? = nil, title: String, agent: String? = nil, commission: Double? = nil, feedealine: Date? = nil, details: String = "", created: Date, schedules: [Schedule]? = nil, payments: [Payment]? = nil, works: [Work]? = nil) {
        self.student = student
        self.title = title
        self.agent = agent
        self.commission = commission
        self.feedealine = feedealine
        self.details = details
        self.created = created
        self.schedules = schedules
        self.payments = payments
        self.works = works
    }
    
    var folderName: String {
        "order_\(self.title.abbreviateText())_\(self.persistentId.uuidString.prefix(3))"
    }
}
