//
//  PaymentsView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 18.03.2025.
//

import SwiftUI

struct PaymentsView: View {

    @ObservedObject var viewModel: MainViewModel
    
    let dataService: PaymentsProtocol
    
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
                        let payment = viewModel.prepareNewPayment(from: viewModel.selectedPayment)
                        CreatePaymentView(order: order, payment: payment, isPresented: $viewModel.showSheetNewPayment, dataService: dataService){}
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
                                dataService: dataService
                            ){
                                viewModel.selectedPayment = nil
                            }
                        }
                    }
                    .disabled(viewModel.selectedPayment == nil)
                    
                    // Кнопка "Удалить"
                    TrashConfirmButton(isPresent: $viewModel.showConfirmDeletePayment, label: "Delete Payment"){
                        if let payment = viewModel.selectedPayment{
                            dataService.delete(payment: payment){
                                viewModel.selectedPayment = nil
                            }
                        }
                    }
                    .disabled(viewModel.selectedPayment == nil) // Кнопка неактивна, если ничего не выбрано
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.1))
                // Заголовки колонок
                
                let titleItems = [
                    TitleColumnItem(title: "Date", alignment: .center, font: .title3, width: 120, borderHeight: 20),
                    TitleColumnItem(title: "Amount", alignment: .center, font: .title3, width: 100, borderHeight: 20),
                    TitleColumnItem(title: "Category", alignment: .center, font: .title3, width: 100, borderHeight: 20),
                    TitleColumnItem(title: "Details", alignment: .center, font: .title3, width: 160, borderHeight: 0)
                ]
                TableHeader(titleItems: titleItems)
                
                // Список с данными
                List(order.payments?.sorted { $0.created ?? Date.distantPast < $1.created ?? Date.distantPast }  ?? []) { payment in
                    ZeroSpacingHStack {
                        DateTimeFormatText(date: payment.created, style: .short)
                            .rightBorderStyle(width: titleItems[0].width, borderHeight: 40)
                        
                        Text("\(payment.amount.formattedAsCurrency())")
                            .rightBorderStyle(width: titleItems[1].width, alignment: .trailing, padding:8, borderHeight: 40)
                        
                        Text("\(payment.category?.name ?? "")")
                            .rightBorderStyle(width: titleItems[2].width, alignment: .trailing, padding:4, borderHeight: 40)
                        
                        Text("\(payment.details)")
                            .rightBorderStyle(width: titleItems[3].width, alignment: .trailing, padding:4)
                        
                        if payment.taxdate != nil {
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
                .listStyle(.plain)
            }
        }
        .padding()
        .contextMenu {
            Button("Повторить") {
                viewModel.showSheetNewPayment = true
            }
//            Button("Увеличить значение") { print("Клик по элементу: \(viewModel.selectedPayment?.details ?? "")") }
//            Button("Уменьшить значение") { print("Клик по элементу: \(viewModel.selectedPayment?.details ?? "")") }
//            Divider()
//            Button("Удалить") { print("Клик по элементу: \(viewModel.selectedPayment?.details ?? "")") }
//                .disabled(viewModel.selectedMeeting == nil)
        }
    }
}

