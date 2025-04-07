//
//  Schedule+Helpers.swift
//  TaskFlow
//
//  Created by alexandergaranin on 07.04.2025.
//

extension Schedule {
   func update(with other: Schedule) {
       self.start = other.start
       self.finish = other.finish
       self.completed = other.completed
       self.cost = other.cost
       self.details = other.details
   }
}
