//
//  DayColumn.swift
//  TaskFlow
//
//  Created by alexandergaranin on 26.03.2025.
//

import SwiftUI

struct DayColumn: View {
    let date: Date
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<24) { _ in
                Rectangle()
                    .fill(isSelected ? Color.blue.opacity(0.05) : Color.gray.opacity(0.05))
                    .frame(height: CalendarConstants.heighRowWeekView)
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color.gray.opacity(0.2)),
                        alignment: .bottom
                    )
            }
        }
        .frame(maxWidth: .infinity)
        .border(Color.gray.opacity(0.2), width: 0.5)
    }
}

#Preview {
    DayColumn(date: Date(), isSelected: true)
}

#Preview {
    DayColumn(date: Date(), isSelected: false)
}
