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
            VStack(spacing: 0) {
                ForEach(0..<24) { hour in
                    HourRow(hour: hour)
//                        .padding(.vertical, 4)
//                    ForEach(0..<4) { hour in
//                        HourRow(hour: hour)
//                            .padding(.vertical, 4)
//                        
//                    }
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
