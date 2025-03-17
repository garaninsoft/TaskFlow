//
//  TaskFlowApp.swift
//  TaskFlow
//
//  Created by alexandergaranin on 15.01.2025.
//

import SwiftUI
import SwiftData

@main
struct TaskFlowApp: App {
    
    // *** Эти примеры возможно пригодятся. Потом удалю.
    //    init() {
    //        // Заменяем названия после запуска приложения
    //        // deleteStandartMenu()
    //        // todo: норм не работает: если изменять пункты меню, то идёт возврат удалённых элементов
    //    }
    //
    //    private func deleteStandartMenu(){
    //        DispatchQueue.main.async {
    //            // Получаем главное меню
    //            guard let mainMenu = NSApplication.shared.mainMenu else { return }
    //
    //            let titleMenusForDelete = ["File", "Edit", "View", "Window", "Help"]
    //            titleMenusForDelete.forEach{ title in
    //                if let menu = mainMenu.item(withTitle: title){
    //                    mainMenu.removeItem(menu)
    //                }
    //            }
    //        }
    //    }
    // ^^^
    
    @State private var selectedStudent: Student? = nil
    @State private var selectedOrder: Order? = nil
    
    @State private var showSheetNewStudent: Bool = false
    @State private var showSheetNewOrder: Bool = false
    
    @State private var showSheetEditStudent: Bool = false
    @State private var showSheetEditOrder: Bool = false
    
    @State private var showConfirmDeleteStudent: Bool = false
    @State private var showConfirmDeleteOrder: Bool = false
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Student.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        @Environment(\.openWindow) var openWindow
        
        WindowGroup {
            MainView(
                selectedStudent: $selectedStudent,
                selectedOrder: $selectedOrder,
                showSheetNewStudent: $showSheetNewStudent,
                showSheetNewOrder: $showSheetNewOrder,
                showSheetEditStudent: $showSheetEditStudent,
                showSheetEditOrder: $showSheetEditOrder,
                showConfirmDeleteStudent: $showConfirmDeleteStudent,
                showConfirmDeleteOrder: $showConfirmDeleteOrder
            )
        }
        .modelContainer(sharedModelContainer)
        .commands {
            CommandMenu("Students") {
                Button("New..."){
                    showSheetNewStudent = true
                }
                if let selectedStudent = selectedStudent {
                    Menu(selectedStudent.name){
                        Button("Edit...") {
                            showSheetEditStudent = true
                        }
                        Button("Delete") {
                            showConfirmDeleteStudent = true
                        }
                    }
                }
            }
            if selectedStudent != nil {
                CommandMenu("Orders") {
                    Button("New..."){
                        showSheetNewOrder = true
                    }
                    if let selectedOrder = selectedOrder{
                        Menu(selectedOrder.title){
                            Button("Edit...") {
                                showSheetEditOrder = true
                            }
                            Button("Delete") {
                                showConfirmDeleteOrder = true
                            }
                        }
                    }
                }
            }
            
        }
        
    }
    
}
