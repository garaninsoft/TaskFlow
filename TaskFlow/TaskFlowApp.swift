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
    
    @StateObject var viewModel = MainViewModel()
    
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
            MainView(viewModel: viewModel)
                .tabItem {
                    Label("Главное", systemImage: "house")
                }
                .sheet(isPresented: $viewModel.showSettings){
                    PaymentCategoriesView(isPresented: $viewModel.showSettings)
                        .environment(\.modelContext, sharedModelContainer.mainContext)
                }
        }
        .modelContainer(sharedModelContainer)
        .commands {
            CommandGroup(after: .appInfo) {
                Divider()
                Button("Settings") {
                    viewModel.showSettings = true
                }
            }
            
            CommandMenu("Students") {
                Button("New..."){
                    viewModel.showSheetNewStudent = true
                }
                if let selectedStudent = viewModel.selectedStudent {
                    Menu(selectedStudent.name){
                        Button("Edit...") {
                            viewModel.showSheetEditStudent = true
                        }
                        Button("Delete") {
                            viewModel.showConfirmDeleteStudent = true
                        }
                    }
                }
            }
            if viewModel.selectedStudent != nil {
                CommandMenu("Orders") {
                    Button("New..."){
                        viewModel.showSheetNewOrder = true
                    }
                    if let selectedOrder = viewModel.selectedOrder{
                        Menu(selectedOrder.title){
                            Button("Edit...") {
                                viewModel.showSheetEditOrder = true
                            }
                            Button("Delete") {
                                viewModel.showConfirmDeleteOrder = true
                            }
                        }
                    }
                }
            }
            if viewModel.selectedOrder != nil {
                if viewModel.selectedTab == .meetings {
                    CommandMenu("Schedule") {
                        Button("New meeting..."){
                            viewModel.showSheetNewMeeting = true
                        }
                        if let selectedMeeting = viewModel.selectedMeeting{
                            Menu(selectedMeeting.details){
                                Button("Edit...") {
                                    viewModel.showSheetEditMeeting = true
                                }
                                Button("Delete") {
                                    viewModel.showConfirmDeleteMeeting = true
                                }
                            }
                        }
                    }
                }
                if viewModel.selectedTab == .payments {
                    CommandMenu("Payments") {
                        Button("New payment..."){
                            viewModel.showSheetNewPayment = true
                        }
                        if let selectedPayment = viewModel.selectedPayment{
                            Menu(selectedPayment.details){
                                Button("Edit...") {
                                    viewModel.showSheetEditPayment = true
                                }
                                Button("Delete") {
                                    viewModel.showConfirmDeletePayment = true
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
