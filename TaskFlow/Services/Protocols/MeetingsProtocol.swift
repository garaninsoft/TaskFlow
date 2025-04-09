//
//  MeetingsProtocol.swift
//  TaskFlow
//
//  Created by alexandergaranin on 24.03.2025.
//
import SwiftData

protocol MeetingsProtocol {
    func create(meeting: Schedule, for order: Order, onSuccess: ()->Void)
    func update(meeting: Schedule, onSuccess: ()->Void)
    func delete(meeting: Schedule, onSuccess: ()->Void)
    
    func getModelContext() -> ModelContext
}
