//
//  ConfirmButton.swift
//  TaskFlow
//
//  Created by alexandergaranin on 17.03.2025.
//

import SwiftUI

struct TrashConfirmButton: View {
    
    @Binding var isPresent: Bool
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {isPresent = true}) {
            Label(label, systemImage: "trash")
        }
        .confirmationDialog("Are you sure?", isPresented: $isPresent) {
            Button("Delete", role: .destructive) {
                withAnimation{
                    // Нужно продумать не удалять, а помечать типа как не активные
                    action()
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This action cannot be undone!")
        }
    }
}


