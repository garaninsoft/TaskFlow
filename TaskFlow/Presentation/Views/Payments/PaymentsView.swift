//
//  PaymentsView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 18.03.2025.
//

import SwiftUI

struct PaymentsView: View {

    @ObservedObject var viewModel: MainViewModel
    
    let paymentProtocol: PaymentsProtocol
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let order = viewModel.selectedOrder{
                // Кастомный Toolbar
                HStack {
                    // Кнопка "Добавить"
                    Button(action: {
                        viewModel.showSheetNewPayment = true
                    }) {
                        Label("Payment", systemImage: "plus")
                    }
                    .sheet(isPresented: $viewModel.showSheetNewPayment) {
                        CreatePaymentView(order: order, isPresented: $viewModel.showSheetNewPayment)
                    }
                    
                    // Кнопка "Редактировать"
                    Button(action: {
                        viewModel.showSheetEditPayment = true
                    }) {
                        Label("Edit", systemImage: "pencil")
                    }
                    .sheet(isPresented: $viewModel.showSheetEditPayment) {
                        if let payment = viewModel.selectedPayment{
                            UpdatePaymentView(
                                payment: payment,
                                isPresented: $viewModel.showSheetEditPayment,
                                actionUpdatePayment: paymentProtocol.actionUpdatePayment
                            )
                        }
                    }
                    .disabled(viewModel.selectedPayment == nil)
                    
                    // Кнопка "Удалить"
                    TrashConfirmButton(isPresent: $viewModel.showConfirmDeletePayment, label: "Delete Payment"){
                        if let payment = viewModel.selectedPayment{
                            paymentProtocol.actionDeletePayment(payment: payment)
                        }
                    }
                    .disabled(viewModel.selectedPayment == nil) // Кнопка неактивна, если ничего не выбрано
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.1))
                // Заголовки колонок
                HStack {
                    Text("Date")
                        .frame(width: 120, alignment: .leading)
                        .font(.headline)
                        .padding(.horizontal, 8)
                    
                    Text("Amount rur")
                        .frame(width: 100, alignment: .leading)
                        .font(.headline)
                        .padding(.horizontal, 8)
                    
                    Text("Category")
                        .frame(width: 100, alignment: .leading)
                        .font(.headline)
                        .padding(.horizontal, 8)
                    
                    Text("Details")
                        .frame(width: 150, alignment: .leading)
                        .font(.headline)
                        .padding(.horizontal, 8)
                    
                    Text("Tax")
                        .frame(width: 50, alignment: .leading)
                        .font(.headline)
                        .padding(.horizontal, 8)
                    
                }
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.1))
                
                // Список с данными
                List(order.payments ?? []) { payment in
                    HStack {
                        DateTimeFormatText(date: payment.created)
                        
                        Text("\(payment.amount.formatted(.number.precision(.fractionLength(2))))")
                            .frame(width: 100, alignment: .leading)
                            .padding(.horizontal, 8)
                        
                        Text("\(payment.category?.name ?? "")")
                            .frame(width: 100, alignment: .leading)
                            .padding(.horizontal, 8)
                        
                        Text("\(payment.details)")
                            .frame(width: 150, alignment: .leading)
                            .padding(.horizontal, 8)
                        
                        if payment.declared {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .frame(width: 50)
                        }else{
                            Text("")
                                .frame(width: 50)
                        }
                    }
                    .contentShape(Rectangle()) // Чтобы вся строка была кликабельной
                    .onTapGesture {
                        viewModel.selectedPayment = payment
                        print("Клик по элементу: \(payment.details)")
                    }
                    .background(viewModel.selectedPayment?.id == payment.id ? Color.blue.opacity(0.2) : Color.clear)
                    .cornerRadius(4)
                }
            }
        }
        .padding()
        .contextMenu {
            Button("Увеличить значение") { print("Клик по элементу: \(viewModel.selectedPayment?.details ?? "")") }
            Button("Уменьшить значение") { print("Клик по элементу: \(viewModel.selectedPayment?.details ?? "")") }
            Divider()
            Button("Удалить") { print("Клик по элементу: \(viewModel.selectedPayment?.details ?? "")") }
                .disabled(viewModel.selectedMeeting == nil)
        }
    }
}

