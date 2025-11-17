//
//  Order+Helpers.swift
//  TaskFlow
//
//  Created by alexandergaranin on 07.04.2025.
//

extension Order {
   func update(with other: Order) {
       self.title = other.title
       self.agent = other.agent
       self.commission = other.commission
       self.feedealine = other.feedealine
       self.details = other.details
       self.created = other.created
   }
}

