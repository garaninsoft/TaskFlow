//
//  Contact.swift
//  TaskFlow
//
//  Created by Александр Гаранин on 25.09.2025.
//

import Foundation
import SwiftData

@Model
final class Contact{
    var student: Student?
    var contactCategory: ContactCategory?
    var title: String
    var details: String
    var created: Date
    var persistentId: UUID = UUID()
    
    init(student: Student? = nil, contactCategory: ContactCategory? = nil, title: String, details: String, created: Date, persistentId: UUID) {
        self.student = student
        self.contactCategory = contactCategory
        self.title = title
        self.details = details
        self.created = created
        self.persistentId = persistentId
    }

}
