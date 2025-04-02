//
//  DraftTableView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 02.04.2025.
//

import SwiftUI

struct DraftTableView: View {
    let schedules: [Schedule]
    @State private var selected: Schedule?
    var body: some View {
        // Заголовки колонок
        HStack(alignment: .center, spacing: 0) {
            Text("Start")
                .frame(width: 120, alignment: .center)
                .font(.title3)
                .overlay(
                    Rectangle()
                        .frame(width: 1, height: 20) // Жёстко заданная высота
                        .foregroundColor(.blue),
                    alignment: .trailing
                )
            
            Text("Finish")
                .frame(width: 120, alignment: .center)
                .font(.title3)
                .overlay(
                    Rectangle()
                        .frame(width: 1, height: 20) // Жёстко заданная высота
                        .foregroundColor(.blue),
                    alignment: .trailing
                )
            
            Text("Completed")
                .frame(width: 120, alignment: .center)
                .font(.title3)
                .overlay(
                    Rectangle()
                        .frame(width: 1, height: 20) // Жёстко заданная высота
                        .foregroundColor(.blue),
                    alignment: .trailing
                )
            
            Text("Cost 60 min")
                .frame(width: 100, alignment: .center)
                .font(.title3)
                .overlay(
                    Rectangle()
                        .frame(width: 1, height: 20) // Жёстко заданная высота
                        .foregroundColor(.blue),
                    alignment: .trailing
                )
            
            Text("Details")
                .frame(width: 150, alignment: .center)
                .font(.title3)
                
            
        }
        .padding(.vertical, 4)
        .background(Color.teal.opacity(0.4))
        
        // Список с данными
        List(schedules.sorted { $0.start ?? Date.distantPast < $1.start ?? Date.distantPast }) { meeting in
            HStack(spacing: 0) {
                DateTimeFormatText(date: meeting.start)
                    .overlay(
                        Rectangle()
                            .frame(width: 1, height: 20) // Жёстко заданная высота
                            .foregroundColor(.blue),
                        alignment: .trailing
                    )
                DateTimeFormatText(date: meeting.finish)
                    .overlay(
                        Rectangle()
                            .frame(width: 1, height: 20) // Жёстко заданная высота
                            .foregroundColor(.blue),
                        alignment: .trailing
                    )
                DateTimeFormatText(date: meeting.completed)
                    .overlay(
                        Rectangle()
                            .frame(width: 1, height: 20) // Жёстко заданная высота
                            .foregroundColor(.blue),
                        alignment: .trailing
                    )
                
                Text("\(meeting.cost.formattedAsCurrency())")
                    .frame(width: 96, alignment: .trailing)
                    .padding(.trailing,4)
                    .overlay(
                        Rectangle()
                            .frame(width: 1, height: 20) // Жёстко заданная высота
                            .foregroundColor(.blue),
                        alignment: .trailing
                    )
                
                Text("\(meeting.details)")
                    .padding(.leading,8)
                    .frame(width: 142, alignment: .leading)

            }
            .contentShape(Rectangle()) // Чтобы вся строка была кликабельной
            .onTapGesture {
                selected = meeting
                print("Клик по элементу: \(meeting.details)")
            }
            .background(selected?.id == meeting.id ? Color.blue.opacity(0.2) : Color.clear)
            
        }
        .listStyle(.plain)
        .padding(.leading, -8)
    }
}

#Preview {
    let schedules = [
        Schedule(start: Date(), finish: Date(), completed: Date(), cost: 135.23, details: "details"),
        Schedule(start: Date(), completed: Date(), cost: 1235.23, details: "details"),
        Schedule(start: Date(), finish: Date(), completed: Date(), cost: 1235.23, details: "details"),
        Schedule(start: Date(), finish: Date(), cost: 1235.23, details: "details"),
        Schedule(start: Date(), finish: Date(), completed: Date(), cost: 1235.23, details: "details")
    ]
    DraftTableView(schedules: schedules)
}
