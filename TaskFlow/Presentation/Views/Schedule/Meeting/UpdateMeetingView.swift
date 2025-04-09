//
//  UpdateMeetingView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 22.03.2025.
//

import SwiftUI

struct UpdateMeetingView: View {
    let meeting: Schedule
    
    @Binding var isPresented: Bool
    let dataService: MeetingsProtocol
    let onSuccess: () -> Void
    
    var body: some View {
        MeetingForm(
            meeting: meeting,
            titleForm: "Update Meeting",
            captionButtonSuccess: "Update",
            isPresented: $isPresented,
            modelContext: dataService.getModelContext()
        ){meeting in
            dataService.update(meeting: meeting, onSuccess: onSuccess)
        }
    }
}
