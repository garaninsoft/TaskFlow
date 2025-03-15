//
//  OrderForm.swift
//  TaskFlow
//
//  Created by alexandergaranin on 05.03.2025.
//

import SwiftUI

struct OrderForm: View {
    
    @Environment(\.dismiss) private var dismiss
    
    init(
        order: Order? = nil,
        titleForm: String,
        captionButtonSuccess: String,
        action: @escaping (Order) -> Void
    ) {
        self.title = order?.title ?? ""
        self.details = order?.details ?? ""
        
        self.titleForm = titleForm
        self.captionButtonSuccess = captionButtonSuccess
        self.action = action
    }

    @State private var details: String
    @State private var title: String

    var titleForm: String
    var captionButtonSuccess: String
    var action: (Order)->Void
    
    @State private var showValidateErrorMsg = false
    
    var body: some View {
        Form {
            Text(titleForm)
                .font(.title2)
            
            TextField("Title", text: $title)
            TextField("Details", text: $details)
            
            HStack {
                
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
                
                Button(captionButtonSuccess) {
                    let order = Order(
                        title: title,
                        details: details,
                        created: Date()
                    )
                    if isValid(order: order){
                        withAnimation {
                            action(order)
                            dismiss()
                        }
                    }else{
                        showValidateErrorMsg.toggle()
                    }
                }
                .buttonStyle(.borderedProminent)
                .sheet(isPresented: $showValidateErrorMsg) {
                    VStack{
                        XMarkButton().onTapGesture { // on tap gesture calls dismissal
                            showValidateErrorMsg.toggle()
                        }
                        .padding(.trailing)
                        Text("Error")
                    }
                }
            }
        }
        .formStyle(.grouped)
    }
    private func isValid(order: Order)->Bool{
        return !(details.isEmpty || title.isEmpty)
    }
}
