//
//  PaymentCategoriesView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 24.03.2025.
//

import SwiftUI
import SwiftData

struct PaymentCategoriesView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var categories: [PaymentCategory]
    
    @Binding var isPresented: Bool
    @State private var selectedCategory: PaymentCategory? = nil
    @State private var showSheetNewCategory: Bool = false
    @State private var showSheetEditCategory: Bool = false
    @State private var showSheetDeleteCategory: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // Кастомный Toolbar
            HStack {
                // Кнопка "Добавить"
                Button(action: {
                    showSheetNewCategory = true
                }) {
                    Label("Category", systemImage: "plus")
                }
                .sheet(isPresented: $showSheetNewCategory) {
                    CreatePaymentCategoryView(isPresented: $showSheetNewCategory){ category in
                        withAnimation{
                            modelContext.insert(category)
                            try? modelContext.save()
                        }
                    }
                }
                
                // Кнопка "Редактировать"
                Button(action: {
                    showSheetEditCategory = true
                }) {
                    Label("Edit", systemImage: "pencil")
                }
                .sheet(isPresented: $showSheetEditCategory) {
                    if let category = selectedCategory{
                        UpdatePaymentCategoryView(
                            category: category,
                            isPresented: $showSheetEditCategory,
                            action: { category in
                                withAnimation{
                                    selectedCategory?.name = category.name
                                    selectedCategory?.details = category.details
                                    selectedCategory?.created = category.created
                                    try? modelContext.save()
                                }
                            }
                        )
                    }
                }
                .disabled(selectedCategory == nil)
                
                // Кнопка "Удалить"
                TrashConfirmButton(isPresent: $showSheetDeleteCategory, label: "Delete Category"){
                    if let category = selectedCategory{
                        withAnimation{
                            modelContext.delete(category)
                            try? modelContext.save()
                        }
                    }
                }
                .disabled(selectedCategory == nil) // Кнопка неактивна, если ничего не выбрано
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
            .background(Color.gray.opacity(0.1))
            // Заголовки колонок
            HStack {
                Text("Name")
                    .frame(width: 150, alignment: .leading)
                    .font(.headline)
                    .padding(.horizontal, 8)
                
                Text("Details")
                    .frame(width: 150, alignment: .leading)
                    .font(.headline)
                    .padding(.horizontal, 8)
                
                Text("Created")
                    .frame(width: 150, alignment: .leading)
                    .font(.headline)
                    .padding(.horizontal, 8)
            }
            .padding(.vertical, 8)
            .background(Color.gray.opacity(0.1))
            
            // Список с данными
            List(categories) { category in
                HStack {
                    Text(category.name)
                        .frame(width: 150, alignment: .leading)
                        .padding(.horizontal, 8)
                    
                    Text(category.details)
                        .frame(width: 150, alignment: .leading)
                        .padding(.horizontal, 8)
                    
                    DateTimeFormatText(date: category.created, format: .format1)
                }
                .contentShape(Rectangle()) // Чтобы вся строка была кликабельной
                .onTapGesture {
                    selectedCategory = category
                    print("Клик по элементу: \(category.name)")
                }
                .background(selectedCategory?.id == category.id ? Color.blue.opacity(0.2) : Color.clear)
                .cornerRadius(4)
            }
        }
        .frame(height: 300)
        .padding()
        // Пока не удалять. Возможно пригодится
//        .contextMenu {
//            Button("Увеличить значение") { print("Клик по элементу: \(selectedCategory?.name ?? "")") }
//            Button("Уменьшить значение") { print("Клик по элементу: \(selectedCategory?.name ?? "")") }
//            Divider()
//            Button("Удалить") { print("Клик по элементу: \(selectedCategory?.name ?? "")") }
//                .disabled(selectedCategory == nil)
//        }
        
        Spacer()
        
        HStack {
            Spacer()
            Button(action: { isPresented = false }) {
                Text("Закрыть")
                    .frame(minWidth: 80)
            }
            .controlSize(.large)
            .keyboardShortcut(.defaultAction)
        }
        .padding()
    }
}

#Preview {
    @Previewable @State var isPresented: Bool = false
    let config = ModelConfiguration(isStoredInMemoryOnly: true) // 1. Конфигурация в памяти
    let container = try! ModelContainer(for: PaymentCategory.self, configurations: config) // 2. Контейнер
    
    // 3. Добавляем тестовые данные
    let context = container.mainContext
    
    let categories = [
        PaymentCategory(name: "Еда", details: "green", created: Date()),
        PaymentCategory(name: "Транспорт", details: "blue", created: Date())
    ]
    
    
    categories.forEach { context.insert($0) }
    
    return PaymentCategoriesView(isPresented: $isPresented)
        .modelContainer(container) // 5. Привязываем контейнер
}
