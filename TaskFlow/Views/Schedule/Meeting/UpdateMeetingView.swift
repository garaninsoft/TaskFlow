//
//  UpdateMeetingView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 22.03.2025.
//

import SwiftUI

struct UpdateMeetingView: View {
    @Environment(\.modelContext) private var modelContext
    let meeting: Schedule
    @Binding var isPresented: Bool
    let actionUpdateMeeting: (Schedule)-> Void
    
    var body: some View {
        MeetingForm(
            meeting: meeting,
            titleForm: "Update Meeting",
            captionButtonSuccess: "Update",
            isPresented: $isPresented,
            action: actionUpdateMeeting
        )
    }
}
