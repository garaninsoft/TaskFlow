//
//  CreateWorkView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 05.04.2025.
//

import SwiftUI

struct CreateWorkView: View {
    var order: Order
    @Binding var isPresented: Bool
    
    var body: some View {
        WorkForm(
            titleForm: "Create Work",
            captionButtonSuccess: "Create",
            isPresented: $isPresented,
            action: {work in
                order.works?.append(work)
            }
        )
    }
}
