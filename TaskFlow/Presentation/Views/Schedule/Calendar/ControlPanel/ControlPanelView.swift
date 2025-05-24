//
//  ControlPanelView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 26.03.2025.
//

import SwiftUI

struct ControlPanelView: View {
    @Binding var selectedDate: Date
    @Binding var calendarMode: CalendarMode
    var body: some View {
        HStack {
            // Кнопки переключения между периодами
            PeriodNavigationButtons(selectedDate: $selectedDate, calendarMode: $calendarMode)
            
            Spacer()
            Button("Сегодня"){
                selectedDate = Date()
            }
            // Сегментированный контрол для выбора режима
            Picker("", selection: $calendarMode) {
                ForEach(CalendarMode.allCases, id: \.self) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 300)
        }
        .padding()
    }
}

