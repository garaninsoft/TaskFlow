//
//  StudentsProtocol.swift
//  TaskFlow
//
//  Created by alexandergaranin on 07.04.2025.
//

protocol StudentsProtocol: OrdersProtocol{
    func create(student: Student, onSuccess: () -> Void)
    func update(student: Student, onSuccess: () -> Void)
    func delete(student: Student, onSuccess: () -> Void) 
}
