//
//  DayCell.swift
//  TaskFlow
//
//  Created by alexandergaranin on 26.03.2025.
//

import SwiftUI

struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let isCurrentMonth: Bool
    
    var body: some View {
        VStack {
            Text(date.formatted(.dateTime.day()))
                .font(.headline)
                .foregroundColor(isCurrentMonth ? (isSelected ? .white : .primary) : .secondary)
                .frame(width: 30, height: 30)
                .background(isSelected ? Color.blue : Color.clear)
                .clipShape(Circle())
            
            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 60)
        .background(isCurrentMonth ? Color.clear : Color.gray.opacity(0.05))
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.gray.opacity(0.1)),
            alignment: .bottom
        )
    }
}

#Preview {
    DayCell(date: Date(), isSelected: false, isCurrentMonth: false)
    DayCell(date: Date(), isSelected: true, isCurrentMonth: false)
    DayCell(date: Date(), isSelected: false, isCurrentMonth: true)
    DayCell(date: Date(), isSelected: true, isCurrentMonth: true)
}
