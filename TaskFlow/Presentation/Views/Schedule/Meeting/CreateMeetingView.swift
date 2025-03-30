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
    
    var body: some View {
        MeetingForm(
            titleForm: "Create Meeting",
            captionButtonSuccess: "Create",
            isPresented: $isPresented,
            action: {meeting in
                order.schedules?.append(meeting)
            }
        )
    }
}

