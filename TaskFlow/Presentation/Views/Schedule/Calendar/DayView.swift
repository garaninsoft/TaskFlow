//
//  DayView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 26.03.2025.
//

import SwiftUI

struct DayView: View {
    @Binding var selectedDate: Date
    var body: some View {
        ScrollView {
            VStack(spacing: 1) {
                ForEach(0..<24) { hour in
                    HourRow(hour: hour)
                    Rectangle()
                        .fill(Color.blue)
                                    .frame(height: 1) // Толщина "spacing"
                }
            }
            .padding()
        }
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
        .padding()
    }
}

#Preview {
    @Previewable @State var selectedDate: Date = Date()
    DayView(selectedDate: $selectedDate)
}
