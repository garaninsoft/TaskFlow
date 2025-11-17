//
//  Student+Helpers.swift
//  TaskFlow
//
//  Created by alexandergaranin on 07.04.2025.
//

extension Student {
   func update(with other: Student) {
       self.name = other.name
       self.contacts = other.contacts
       self.contacts2 = other.contacts2
       self.messenger = other.messenger
       self.messenger2 = other.messenger2
       self.details = other.details
       self.created = other.created
       self.closed = other.closed
   }
}
