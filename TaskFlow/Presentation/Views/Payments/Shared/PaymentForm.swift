//
//  PaymentForm.swift
//  TaskFlow
//
//  Created by alexandergaranin on 24.03.2025.
//

import SwiftUI
import SwiftData


struct PaymentForm: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var categories: [PaymentCategory]
    
    init(
        payment: Payment? = nil,
        titleForm: String,
        captionButtonSuccess: String,
        isPresented: Binding<Bool>,
        action: @escaping (Payment) -> Void
    ) {
        
        self.created = payment?.created
        self.category = payment?.category
        self.amount = payment?.amount ?? 0
        self.details = payment?.details ?? ""
        self.taxdate = payment?.taxdate
        
        self.titleForm = titleForm
        self.captionButtonSuccess = captionButtonSuccess
        self.action = action
        self._isPresented = isPresented
    }
    
    // Поля для ввода данных
    @State private var created: Date?
    @State private var category: PaymentCategory?
    @State private var amount: Double
    @State private var details: String
    @State private var taxdate: Date?
    
    @Binding var isPresented: Bool
    
    var titleForm: String
    var captionButtonSuccess: String
    var action: (Payment)->Void
    
    @State private var showValidateErrorMsg = false
    
    var body: some View {
        Form {
            Text(titleForm)
                .font(.title2)
            
            // Поле для выбора даты начала
            DatePickerButton(caption:"Created", selectedDate: $created)
            
            // Поле для ввода стоимости
            TextField("Amount (rur)", value: $amount, format: .number)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Picker("Category", selection: $category) {
                Text("Не выбрано").tag(nil as PaymentCategory?)
                ForEach(categories) { categori in
                    Text(categori.name).tag(categori as PaymentCategory?)
                }
            }
            .pickerStyle(.menu)
            
            // Поле для ввода деталей
            TextField("Details", text: $details)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        
            DatePickerButton(caption:"Declared", selectedDate: $taxdate)
            
            HStack {
                Button("Cancel", role: .cancel) {
                    isPresented = false
                }
                
                Button(captionButtonSuccess) {
                    
                    let payment = Payment(
                        category: category,
                        amount: amount,
                        taxdate: taxdate,
                        details: details,
                        created: created
                    )
                    if isValid(payment: payment){
                        withAnimation {
                            action(payment)
                        }
                        isPresented = false
                    }else{
                        showValidateErrorMsg = true
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .alert("Ошибка", isPresented: $showValidateErrorMsg) {
            Button("OK", role: .cancel) {
                showValidateErrorMsg = false
            }
        } message: {
            Text("Error")
        }
        .formStyle(.grouped)
    }
    private func isValid(payment: Payment)->Bool{
        return payment.amount != 0 && payment.created != nil
    }
}

//#Preview {
//    @Previewable @State var isPresent: Bool = false
//    PaymentForm(payment: nil, titleForm: "Title Form", captionButtonSuccess: "Caption", isPresented: $isPresent) {_ in }
//}
