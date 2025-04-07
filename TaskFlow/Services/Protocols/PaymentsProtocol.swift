//
//  PaymentsProtocol.swift
//  TaskFlow
//
//  Created by alexandergaranin on 24.03.2025.
//

protocol PaymentsProtocol {
    func create(payment: Payment, for order: Order, onSuccess: ()->Void)
    func update(payment: Payment, onSuccess: ()->Void)
    func delete(payment: Payment, onSuccess: ()->Void)
}
