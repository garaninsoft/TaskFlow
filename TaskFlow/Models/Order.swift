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
    var details: String
    var created: Date
    var schedules: [Schedule]
    var payments: [Payment]
    
    init(student: Student? = nil, details: String, created: Date, schedules: [Schedule], payments: [Payment]) {
        self.student = student
        self.details = details
        self.created = created
        self.schedules = schedules
        self.payments = payments
    }
}
