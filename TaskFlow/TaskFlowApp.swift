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
    @State private var selectedMeeting: Schedule? = nil
    
    
    @State private var showSheetNewStudent: Bool = false
    @State private var showSheetNewOrder: Bool = false
    @State private var showSheetNewMeeting: Bool = false
    
    @State private var showSheetEditStudent: Bool = false
    @State private var showSheetEditOrder: Bool = false
    @State private var showSheetEditMeeting: Bool = false
    
    @State private var showConfirmDeleteStudent: Bool = false
    @State private var showConfirmDeleteOrder: Bool = false
    @State private var showConfirmDeleteMeeting: Bool = false
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            PaymentCategory.self,
            Order.self,
            Payment.self,
            Schedule.self,
            Student.self
        ])
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
                selectedMeeting: $selectedMeeting,
                showSheetNewStudent: $showSheetNewStudent,
                showSheetNewOrder: $showSheetNewOrder,
                showSheetNewMeeting: $showSheetNewMeeting,
                showSheetEditStudent: $showSheetEditStudent,
                showSheetEditOrder: $showSheetEditOrder,
                showSheetEditMeeting: $showSheetEditMeeting,
                showConfirmDeleteStudent: $showConfirmDeleteStudent,
                showConfirmDeleteOrder: $showConfirmDeleteOrder,
                showConfirmDeleteMeeting: $showConfirmDeleteMeeting
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
            if selectedOrder != nil {
                CommandMenu("Schedule") {
                    Button("New meeting..."){
                        showSheetNewMeeting = true
                    }
                    if let selectedMeeting = selectedMeeting{
                        Menu(selectedMeeting.details){
                            Button("Edit...") {
                                showSheetEditMeeting = true
                            }
                            Button("Delete") {
                                showConfirmDeleteMeeting = true
                            }
                        }
                    }
                }
            }
            
        }
        
    }
    
}
