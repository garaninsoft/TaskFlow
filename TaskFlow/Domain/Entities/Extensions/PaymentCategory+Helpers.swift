//
//  PaymentCategory+Helpers.swift
//  TaskFlow
//
//  Created by alexandergaranin on 07.04.2025.
//

extension PaymentCategory {
   func update(with other: PaymentCategory) {
       self.name = other.name
       self.details = other.details
       self.created = other.created
   }
}
