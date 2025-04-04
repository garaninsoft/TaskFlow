//
//  DraftTableView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 02.04.2025.
//

import SwiftUI

struct TitleColumnItem: Hashable{
    let title: String
    let alignment: Alignment
    let font: Font
    let width: CGFloat
    let borderHeight: CGFloat
    
    func hash(into hasher: inout Hasher) {
           hasher.combine(title)
           hasher.combine(width)
       }
       
       static func == (lhs: Self, rhs: Self) -> Bool {
           lhs.title == rhs.title && lhs.width == rhs.width
       }
}

struct TitleTableView: View {
    let titleItems: [TitleColumnItem]
    var body: some View {
        List{ // Это костыль для выравнивания
            HStack(spacing: 0) {
                ForEach(titleItems, id: \.self){ item in
                    Text(item.title)
                        .font(item.font)
                        .rightBorderStyle(width: item.width, alignment: item.alignment, borderHeight: item.borderHeight)
                }
            }
            .padding(.vertical, 4)
            .background(Color.teal.opacity(0.4))
        }
        .listStyle(.plain)
        .environment(\.defaultMinListRowHeight, 40) // Высота строки
        .frame(height: 40) // Точная высота списка
        .scrollDisabled(true) // Отключаем скролл
        
    }
}


struct DraftTableView: View {
    let schedules: [Schedule]
    let titleItems: [TitleColumnItem]
    
    @State private var selected: Schedule?
    
    var body: some View {
        // Заголовки колонок
        TitleTableView(titleItems: titleItems)
        
        // Список с данными
        List(schedules.sorted { $0.start ?? Date.distantPast < $1.start ?? Date.distantPast }) { meeting in
            HStack(spacing: 0) {
                DateTimeFormatText(date: meeting.start)
                    .rightBorderStyle(width: titleItems[0].width, borderHeight: 40)
                
                DateTimeFormatText(date: meeting.finish)
                    .rightBorderStyle(width: titleItems[1].width, borderHeight: 40)
                
                DateTimeFormatText(date: meeting.completed)
                    .rightBorderStyle(width: titleItems[2].width, borderHeight: 40)
                
                Text("\(meeting.cost.formattedAsCurrency())")
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
        .listStyle(.bordered)
//        .padding(0)
    }
}

extension View {
    func rightBorderStyle(
        width: CGFloat,
        alignment: Alignment = .trailing,
        padding: CGFloat = 0,
        borderHeight: CGFloat? = nil,
        borderСolor: Color = .gray
    ) -> some View {
        self
            .frame(width: width - padding, alignment: alignment)
            .padding(alignment == .leading ? .leading : .trailing, padding)
            .rightBorder(height: borderHeight, color: borderСolor)
    }
}

extension View {
    @ViewBuilder
    func rightBorder(height: CGFloat? = 20, color: Color = .gray) -> some View {
        if let height = height{
            self.overlay(
                Rectangle()
                    .frame(width: 1, height: height)
                    .foregroundColor(color),
                alignment: .trailing
            )
        } else{
            self
        }
    }
}


#Preview {
    let titleItems = [
        TitleColumnItem(title: "Start", alignment: .center, font: .title3, width: 100, borderHeight: 20),
        TitleColumnItem(title: "Finish", alignment: .center, font: .title3, width: 100, borderHeight: 20),
        TitleColumnItem(title: "Completed", alignment: .center, font: .title3, width: 100, borderHeight: 20),
        TitleColumnItem(title: "Cost 60 min", alignment: .center, font: .title3, width: 90, borderHeight: 20),
        TitleColumnItem(title: "Details", alignment: .center, font: .title3, width: 150, borderHeight: 0)
    ]
    let schedules = [
        Schedule(start: Date(), finish: Date(), completed: Date(), cost: 135.23, details: "details"),
        Schedule(start: Date(), completed: Date(), cost: 1235.23, details: "details"),
        Schedule(start: Date(), finish: Date(), completed: Date(), cost: 1235.23, details: "details"),
        Schedule(start: Date(), finish: Date(), cost: 1235.23, details: "details"),
        Schedule(start: Date(), finish: Date(), completed: Date(), cost: 1235.23, details: "details")
    ]
    
    DraftTableView(schedules: schedules, titleItems: titleItems)
}
