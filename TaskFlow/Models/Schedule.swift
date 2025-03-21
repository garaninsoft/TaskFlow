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
    var finish: Date? = nil
    var completed: Date? = nil
    var cost: Float
    var details: String
    
    //start     - начало запланированного занятия (есть всегда не nil)
    //finish    - конец запланированного занятия  (проставляется по факту завершения. по finish идёт расчёт стоимости)
    //completed - когда закончилось фактически    (проставляется по факту завершения. по completed идёт понимание
    //                                             перерасхода времени)
    //cost      - стоимость часа занятий руб/60мин
    // * если completed == nil -> занятий не было
    // * стоимость заносим в первое занятие. Эта стоимость будет считаться договорной. Далее будем её копировать и
    // * переподставлять
    init(order: Order? = nil, start: Date?, finish: Date?, completed: Date?, cost: Float, details: String) {
        self.order = order
        self.start = start
        self.finish = finish
        self.completed = completed
        self.cost = cost
        self.details = details
    }
}
