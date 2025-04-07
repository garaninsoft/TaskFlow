//
//  OrdersProtocol.swift
//  TaskFlow
//
//  Created by alexandergaranin on 24.03.2025.
//

protocol OrdersProtocol: MeetingsProtocol, WorksProtocol, PaymentsProtocol{
    func create(order: Order, for student: Student, onSuccess: ()->Void)
    func update(order: Order, onSuccess: ()->Void)
    func delete(order: Order, onSuccess: ()->Void)
}
