//
//  Schedule.swift
//  TaskFlow
//
//  Created by alexandergaranin on 13.02.2025.
//

import Foundation
import SwiftData

@Model
final class Schedule {
    var order: Order?
    var start: Date
    var finish: Date
    var completed: Date
    var details: String
    
    //start     - начало запланированного занятия
    //finish    - конец запланированного занятия
    //completed - когда закончилось фактически
    // если текущая дата больше finish, а completed пустой -> занятий не было
    init(order: Order, start: Date, finish: Date, completed: Date, details: String) {
        self.order = order
        self.start = start
        self.finish = finish
        self.completed = completed
        self.details = details
    }
}
