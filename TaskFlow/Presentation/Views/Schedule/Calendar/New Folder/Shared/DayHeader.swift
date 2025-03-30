//
//  DayHeader.swift
//  TaskFlow
//
//  Created by alexandergaranin on 26.03.2025.
//

import SwiftUI

struct DayHeader: View {
    let date: Date
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Text(date.formatted(.dateTime.weekday(.abbreviated)))
                .font(.caption)
                .foregroundColor(isSelected ? .blue : .secondary)
            
            Text(date.formatted(.dateTime.day()))
                .font(.headline)
                .foregroundColor(isSelected ? .blue : .primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(isSelected ? Color.blue.opacity(0.1) : Color.clear)
        .cornerRadius(8)
    }
}

#Preview {
    DayHeader(date: Date(), isSelected: true)
    DayHeader(date: Date(), isSelected: false)
}
