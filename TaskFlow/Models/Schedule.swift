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
    var cost: Float
    var details: String
    
    //start     - начало запланированного занятия
    //finish    - конец запланированного занятия
    //completed - когда закончилось фактически
    //cost      - стоимость часа занятий руб/60мин
    // если текущая дата больше finish, а completed пустой -> занятий не было
    // стоимость заносим в первое занятие. Эта стоимость будет считаться договорной. Далее будем её копировать и подсталять
    init(order: Order? = nil, start: Date, finish: Date, completed: Date, cost: Float, details: String) {
        self.order = order
        self.start = start
        self.finish = finish
        self.completed = completed
        self.cost = cost
        self.details = details
    }
}
