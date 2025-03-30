//
//  StudentStatisticTaxView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 30.03.2025.
//

import SwiftUI

struct StudentStatisticTaxView: View {
    
    let student: Student
    
    var body: some View {
        VStack(spacing: 16) {
            // Заголовок
            Text("Декларация")
                .font(.title3.bold())
                .padding(.top, 12)
            
            // Таблица
            VStack(spacing: 0) {
                // Заголовки колонок
                HStack {
                    Text("Категория")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Учтено")
                        .frame(width: 150, alignment: .trailing)
                    Text("Неучтено")
                        .frame(width: 150, alignment: .trailing)
                }
                .font(.subheadline.bold())
                .foregroundColor(.secondary)
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background(Color(.controlBackgroundColor))
                .cornerRadius(4)
                
                // Строки данных
                ScrollView {
                    LazyVStack(spacing: 1) {
                        ForEach(student.statisticTaxItems) { record in
                            HStack {
                                Text(record.category)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                CurrencyView(amount: record.declared)
                                    .frame(width: 150, alignment: .trailing)
                                
                                CurrencyView(amount: record.undeclared)
                                    .frame(width: 150, alignment: .trailing)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color(.windowBackgroundColor))
                        }
                    }
                    .padding(1)
                    .background(Color(.separatorColor))
                }
                .frame(minHeight: 200, maxHeight: 400)
                .cornerRadius(6)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
            }
            .padding(.horizontal)
        }
        .frame(minWidth: 500, idealWidth: 550, maxWidth: .infinity,
               minHeight: 300, idealHeight: 350, maxHeight: .infinity)
        .background(Color(.windowBackgroundColor))
    }
}
