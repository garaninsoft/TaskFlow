//
//  Сategory.swift
//  TaskFlow
//
//  Created by alexandergaranin on 17.03.2025.
//

import Foundation
import SwiftData

@Model
final class ContactCategory{
    var name: String
    var details: String
    var created: Date
    var contacts: [Contact]?
    
    init(name: String, details: String, created: Date, contacts: [Contact]? = nil) {
        self.name = name
        self.details = details
        self.created = created
        self.contacts = contacts
    }
}
