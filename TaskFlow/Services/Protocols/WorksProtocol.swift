//
//  WorksProtocol.swift
//  TaskFlow
//
//  Created by alexandergaranin on 05.04.2025.
//

protocol WorksProtocol {
    func create(work: Work, for order: Order, onSuccess: ()->Void)
    func update(work: Work, onSuccess: ()->Void)
    func delete(work: Work, onSuccess: ()->Void)
}
