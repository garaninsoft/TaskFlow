//
//  TableHeader.swift
//  TaskFlow
//
//  Created by alexandergaranin on 05.04.2025.
//

import SwiftUI

struct TableHeader: View {
    let titleItems: [TitleColumnItem]
    let rowHeight: CGFloat
    
    init(titleItems: [TitleColumnItem], rowHeight: CGFloat = 40) {
            self.titleItems = titleItems
            self.rowHeight = rowHeight
        }
    
    var body: some View {
        List{ // Это костыль для выравнивания
            ZeroSpacingHStack {
                ForEach(titleItems, id: \.self){ item in
                    Text(item.title)
                        .font(item.font)
                        .rightBorderStyle(width: item.width, alignment: item.alignment, borderHeight: item.borderHeight, borderСolor: .white)
                }
            }
            .padding(.vertical, 4)
            .foregroundColor(.white)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.cyan)
            )
        }
        .listStyle(.plain)
        .environment(\.defaultMinListRowHeight, rowHeight) // Высота строки
        .frame(height: rowHeight) // Точная высота списка
        .scrollDisabled(true) // Отключаем скролл
        
    }
}

