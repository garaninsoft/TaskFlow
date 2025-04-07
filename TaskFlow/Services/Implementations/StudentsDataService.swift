//
//  OrderService.swift
//  TaskFlow
//
//  Created by alexandergaranin on 07.04.2025.
//
import SwiftUI
import SwiftData

class StudentsDataService: StudentsProtocol {
    private var modelContext: ModelContext
    @ObservedObject var viewModel: MainViewModel
    
    init(modelContext: ModelContext, viewModel: MainViewModel) {
        self.modelContext = modelContext
        self.viewModel = viewModel
    }
    
    // student -------------------------------------------
    func create(student: Student, onSuccess: () -> Void) {
        withAnimation{
            modelContext.insert(student)
            if (try? modelContext.save()) != nil { onSuccess() }
        }
    }
    
    func update(student: Student, onSuccess: () -> Void) {
        withAnimation{
            viewModel.selectedStudent?.update(with: student)
            if (try? modelContext.save()) != nil { onSuccess() }
        }
    }
    
    func delete(student: Student, onSuccess: () -> Void) {
        withAnimation{
            modelContext.delete(student)
            if (try? modelContext.save()) != nil { onSuccess() }
        }
    }
    
    // order -------------------------------------------
    func create(order: Order, for student: Student, onSuccess: () -> Void) {
        withAnimation{
            student.orders?.append(order)
            if (try? modelContext.save()) != nil { onSuccess() }
        }
    }
    
    func update(order: Order, onSuccess: () -> Void) {
        withAnimation{
            viewModel.selectedOrder?.update(with: order)
            if (try? modelContext.save()) != nil { onSuccess() }
        }
    }
    
    func delete(order: Order, onSuccess: () -> Void) {
        withAnimation{
            modelContext.delete(order)
            if (try? modelContext.save()) != nil { onSuccess() }
        }
    }
    
    // meeting -------------------------------------------
    func create(meeting: Schedule, for order: Order, onSuccess: () -> Void) {
        withAnimation{
            order.schedules?.append(meeting)
            if (try? modelContext.save()) != nil { onSuccess() }
        }
    }
    
    func update(meeting: Schedule, onSuccess: () -> Void) {
        withAnimation{
            viewModel.selectedMeeting?.update(with: meeting)
            if (try? modelContext.save()) != nil { onSuccess() }
        }
    }
    
    func delete(meeting: Schedule, onSuccess: () -> Void) {
        withAnimation{
            modelContext.delete(meeting)
            if (try? modelContext.save()) != nil { onSuccess() }
        }
    }
    
    // work -------------------------------------------
    func create(work: Work, for order: Order, onSuccess: () -> Void) {
        withAnimation{
            order.works?.append(work)
            if (try? modelContext.save()) != nil { onSuccess() }
        }
    }
    
    func update(work: Work, onSuccess: () -> Void) {
        withAnimation{
            viewModel.selectedWork?.update(with: work)
            if (try? modelContext.save()) != nil { onSuccess() }
        }
    }
    
    func delete(work: Work, onSuccess: () -> Void) {
        withAnimation{
            modelContext.delete(work)
            if (try? modelContext.save()) != nil { onSuccess() }
        }
    }
    
    // payment -------------------------------------------
    func create(payment: Payment, for order: Order, onSuccess: () -> Void) {
        withAnimation{
            order.payments?.append(payment)
            if (try? modelContext.save()) != nil { onSuccess() }
        }
    }
    
    func update(payment: Payment, onSuccess: () -> Void) {
        withAnimation {
                viewModel.selectedPayment?.update(with: payment)
                if (try? modelContext.save()) != nil { onSuccess() }
            }
    }
    
    func delete(payment: Payment, onSuccess: () -> Void) {
        withAnimation{
            modelContext.delete(payment)
            if (try? modelContext.save()) != nil { onSuccess() }
        }
    }
}
