//
//  TitleTableView_Preview.swift
//  TaskFlow
//
//  Created by alexandergaranin on 05.04.2025.
//

import SwiftUI

struct DraftTableView: View {
    let schedules: [Schedule]
    let titleItems: [TitleColumnItem]
    
    @State private var selected: Schedule?
    
    var body: some View {
        
        // Заголовки колонок
        TableHeader(titleItems: titleItems)
        
        // Список с данными
        List(schedules.sorted { $0.start ?? Date.distantPast < $1.start ?? Date.distantPast }) { meeting in
            ZeroSpacingHStack {
                DateTimeFormatText(date: meeting.start)
                    .rightBorderStyle(width: titleItems[0].width, borderHeight: 40)
                
                DateTimeFormatText(date: meeting.finish)
                    .rightBorderStyle(width: titleItems[1].width, borderHeight: 40)
                
                DateTimeFormatText(date: meeting.completed)
                    .rightBorderStyle(width: titleItems[2].width, borderHeight: 40)
                
                Text("\(meeting.cost.formattedAsCurrency())")
                    .font(.system(.subheadline, design: .monospaced))
                            .foregroundColor(.blue)
                            .padding(4)
                    .rightBorderStyle(width: titleItems[3].width, alignment: .trailing, padding:8, borderHeight: 40)
                
                Text("\(meeting.details)")
                    .rightBorderStyle(width: titleItems[4].width, alignment: .leading, padding:8)

            }
            .contentShape(Rectangle()) // Чтобы вся строка была кликабельной
            .onTapGesture {
                selected = meeting
                print("Клик по элементу: \(meeting.details)")
            }
            .background(selected?.id == meeting.id ? Color.blue.opacity(0.2) : Color.clear)
            
        }
        .listStyle(.plain)
    }
}


//#Preview {
//    let titleItems = [
//        TitleColumnItem(title: "Start", alignment: .center, font: .title3, width: 100, borderHeight: 20),
//        TitleColumnItem(title: "Finish", alignment: .center, font: .title3, width: 100, borderHeight: 20),
//        TitleColumnItem(title: "Completed", alignment: .center, font: .title3, width: 100, borderHeight: 20),
//        TitleColumnItem(title: "Cost 60 min", alignment: .center, font: .title3, width: 90, borderHeight: 20),
//        TitleColumnItem(title: "Details", alignment: .center, font: .title3, width: 150, borderHeight: 0)
//    ]
//    let schedules = [
//        Schedule(start: Date(), finish: Date(), completed: Date(), cost: 135.23, details: "details"),
//        Schedule(start: Date(), completed: Date(), cost: 1235.23, details: "details"),
//        Schedule(start: Date(), finish: Date(), completed: Date(), cost: 1235.23, details: "details"),
//        Schedule(start: Date(), finish: Date(), cost: 1235.23, details: "details"),
//        Schedule(start: Date(), finish: Date(), completed: Date(), cost: 1235.23, details: "details")
//    ]
//    
//    DraftTableView(schedules: schedules, titleItems: titleItems)
//}
