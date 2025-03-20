//
//  PaymentsView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 18.03.2025.
//

import SwiftUI

struct PaymentsView: View {
    let headers: [String]
    let data: [[String]]
    let columnWidths: [CGFloat] // Массив ширин столбцов
    
    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            VStack(alignment: .leading) {
                HStack {
                    ForEach(headers.indices, id: \.self) { index in
                        Text(headers[index])
                            .font(.headline)
                            .padding(.horizontal)
                            .frame(width: columnWidths[index], alignment: .leading) // Устанавливаем ширину
                    }
                }
                Divider()
                
                ForEach(data.indices, id: \.self) { rowIndex in
                    HStack {
                        ForEach(data[rowIndex].indices, id: \.self) { columnIndex in
                            Text(data[rowIndex][columnIndex])
                                .padding(.horizontal)
                                .frame(width: columnWidths[columnIndex], alignment: .leading) // Устанавливаем ширину
                        }
                    }
                    if rowIndex < data.count - 1 {
                        Divider()
                    }
                }
            }
            .padding()
            .frame(minWidth: 600, minHeight: 400) // Минимальный размер, чтобы скролл работал
        }
    }
}

