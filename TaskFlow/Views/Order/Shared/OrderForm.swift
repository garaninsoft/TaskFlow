//
//  OrderForm.swift
//  TaskFlow
//
//  Created by alexandergaranin on 05.03.2025.
//

import SwiftUI

struct OrderForm: View {
    
    init(
        order: Order? = nil,
        titleForm: String,
        captionButtonSuccess: String,
        isPresented: Binding<Bool>,
        action: @escaping (Order) -> Void
    ) {
        self.title = order?.title ?? ""
        self.details = order?.details ?? ""
        
        self.titleForm = titleForm
        self.captionButtonSuccess = captionButtonSuccess
        self.action = action
        self._isPresented = isPresented
    }

    @State private var details: String
    @State private var title: String
    
    @Binding var isPresented: Bool

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
                    isPresented = false
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
                        }
                        isPresented = false
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
