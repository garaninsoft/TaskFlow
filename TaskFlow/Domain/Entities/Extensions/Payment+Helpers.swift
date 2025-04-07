//
//  Payment+Helpers.swift
//  TaskFlow
//
//  Created by alexandergaranin on 07.04.2025.
//

extension Payment {
   func update(with other: Payment) {
       self.created = other.created
       self.amount = other.amount
       self.category = other.category
       self.details = other.details
       self.declared = other.declared
   }
}
