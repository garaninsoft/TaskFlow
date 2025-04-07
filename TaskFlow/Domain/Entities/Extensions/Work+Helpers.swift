//
//  Work+Helpers.swift
//  TaskFlow
//
//  Created by alexandergaranin on 07.04.2025.
//

extension Work {
   func update(with other: Work) {
       self.created = other.created
       self.completed = other.completed
       self.cost = other.cost
       self.details = other.details
   }
}
