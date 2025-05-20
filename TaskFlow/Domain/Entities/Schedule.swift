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
    var start: Date?
    var finish: Date?
    var completed: Date?
    var cost: Double
    var details: String
    
    //start     - начало запланированного занятия (есть всегда не nil)
    //finish    - конец запланированного занятия  (по finish идёт расчёт стоимости и планируется время занятия)
    //completed - когда закончилось фактически    (проставляется по факту завершения. по completed идёт понимание
    //                                             перерасхода времени)
    //cost      - стоимость часа занятий руб/60мин
    // * если completed == nil -> занятий не было
    init(order: Order? = nil, start: Date? = nil, finish: Date? = nil, completed: Date? = nil, cost: Double = 0.0, details: String = "") {
        self.order = order
        self.start = start
        self.finish = finish
        self.completed = completed
        self.cost = cost
        self.details = details
    }
}
