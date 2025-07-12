//
//  OrderForm.swift
//  TaskFlow
//
//  Created by alexandergaranin on 05.03.2025.
//

import SwiftUI

struct OrderForm: View {
    @State private var title: String
    @State private var details: String
    @State private var created: Date?
    
    @State private var errorMessage: String = ""
    
    @Binding var isPresented: Bool

    var titleForm: String
    var captionButtonSuccess: String
    var action: (Order)->Void
    
    @State private var showValidateErrorMsg = false
    
    init(
        order: Order? = nil,
        titleForm: String,
        captionButtonSuccess: String,
        isPresented: Binding<Bool>,
        action: @escaping (Order) -> Void
    ) {
        self.title = order?.title ?? ""
        self.details = order?.details ?? ""
        self.created = order?.created
        
        self.titleForm = titleForm
        self.captionButtonSuccess = captionButtonSuccess
        self.action = action
        self._isPresented = isPresented
    }
    
    var body: some View {
        Form {
            Text(titleForm)
                .font(.title2)
            
            TextField("Title", text: $title)
            TextField("Details", text: $details)
            DatePickerButton(caption:"Created", selectedDate: $created)
            
            HStack {
                
                Button("Cancel", role: .cancel) {
                    isPresented = false
                }
                
                Button(captionButtonSuccess) {
                    if let order = getValid(){
                        withAnimation {
                            action(order)
                        }
                        isPresented = false
                    }else{
                        showValidateErrorMsg.toggle()
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
            Text(errorMessage)
        }
        .formStyle(.grouped)
    }
    private func getValid() -> Order?{
        if title.isEmpty{
            errorMessage = "Нет названия Заказа"
            return nil
        }
        if let created = created{
            return Order(
                title: title,
                details: details,
                created: created
            )
        }
        errorMessage = "Нет даты Заказа"
        return nil
    }
}
