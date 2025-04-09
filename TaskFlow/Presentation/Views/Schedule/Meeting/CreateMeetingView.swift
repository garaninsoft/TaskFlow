//
//  CreateOrderView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 05.03.2025.
//

import SwiftUI

struct CreateMeetingView: View {
    var order: Order
    
    @Binding var isPresented: Bool
    let dataService: MeetingsProtocol
    let onSuccess: () -> Void
    
    var body: some View {
        MeetingForm(
            titleForm: "Create Meeting",
            captionButtonSuccess: "Create",
            isPresented: $isPresented,
            modelContext: dataService.getModelContext()
        ){meeting in
            dataService.create(meeting: meeting, for: order, onSuccess: onSuccess)
        }
    }
}

