//
//  MainViewModel.swift
//  TaskFlow
//
//  Created by alexandergaranin on 23.03.2025.
//
import SwiftUI

class MainViewModel: ObservableObject {
    @Published var selectedStudent: Student? = nil
    @Published var selectedOrder: Order? = nil
    @Published var selectedMeeting: Schedule? = nil
    @Published var selectedPayment: Payment? = nil

    @Published var showSheetNewStudent: Bool = false
    @Published var showSheetNewOrder: Bool = false
    @Published var showSheetNewMeeting: Bool = false
    @Published var showSheetNewPayment: Bool = false

    @Published var showSheetEditStudent: Bool = false
    @Published var showSheetEditOrder: Bool = false
    @Published var showSheetEditMeeting: Bool = false
    @Published var showSheetEditPayment: Bool = false

    @Published var showConfirmDeleteStudent: Bool = false
    @Published var showConfirmDeleteOrder: Bool = false
    @Published var showConfirmDeleteMeeting: Bool = false
    @Published var showConfirmDeletePayment: Bool = false
    
    @Published var selectedOrderDetailsTab: EOrderDetails = .meetings
    
    @Published var showSheetStudentStatistics: Bool = false
    @Published var showSheetOrderStatistics: Bool = false
    
    @Published var showSettings: Bool = false
}
