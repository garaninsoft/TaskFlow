//
//  PaymentCategoryForm.swift
//  TaskFlow
//
//  Created by alexandergaranin on 25.03.2025.
//

import SwiftUI

struct PaymentCategoryForm: View {
    init(
        category: PaymentCategory? = nil,
        titleForm: String,
        captionButtonSuccess: String,
        isPresented: Binding<Bool>,
        action: @escaping (PaymentCategory) -> Void
    ) {
        self.name = category?.name ?? ""
        self.details = category?.details ?? ""
        self.created = category?.created
        
        self.titleForm = titleForm
        self.captionButtonSuccess = captionButtonSuccess
        self.action = action
        self._isPresented = isPresented
    }
    
    @State private var name: String
    @State private var created: Date?
    @State private var details: String
    
    @Binding var isPresented: Bool

    var titleForm: String
    var captionButtonSuccess: String
    var action: (PaymentCategory)->Void
    
    @State private var showValidateErrorMsg = false
    
    var body: some View {
        Form {
            Text(titleForm)
                .font(.title2)
            
            TextField("Name", text: $name)
            TextField("Details", text: $details)
            DatePickerButton(caption:"Created", selectedDate: $created)
            
            HStack {
                Button("Cancel", role: .cancel) {
                    isPresented = false
                }
                
                Button(captionButtonSuccess) {
                    let category = PaymentCategory(
                        name: name,
                        details: details,
                        created: created ?? Date()
                    )
                    if isValid(category: category){
                        withAnimation {
                            action(category)
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
            Text("Error")
        }
        .formStyle(.grouped)
    }
    private func isValid(category: PaymentCategory)->Bool{
        return !name.isEmpty
    }
}

//#Preview {
//    @Previewable @State var isPresent: Bool = false
//    PaymentCategoryForm(titleForm: "Title Form", captionButtonSuccess: "Success", isPresented: $isPresent){_ in}
//}
