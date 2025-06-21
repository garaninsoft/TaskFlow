//
//  TaskFlowApp.swift
//  TaskFlow
//
//  Created by alexandergaranin on 15.01.2025.
//

import SwiftUI
import SwiftData

enum EWindowGroup: Int {
    case calendar, main
}

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
    
    @State private var showSettings: Bool = false
    @State private var showPathDB: Bool = false
    @State private var showBackupPathDB: Bool = false
    
    private let backupRepository = BackupRepository()
    @State private var backupURL: URL?
    @State private var error: Error?
    @State private var storeURL: URL?
    
    @StateObject private var folderViewModel = FolderViewModel()
    
    let schema = Schema([
        PaymentCategory.self,
        Order.self,
        Payment.self,
        Schedule.self,
        Student.self,
        Work.self
    ])
    
    var sharedModelContainer: ModelContainer
    
    init() {
        do {
            let dbURL = URL(filePath:Constants.bdPath.appending(Constants.bdName))
            
            let config = ModelConfiguration(
                schema: schema,  // Ваша схема моделей
                url: dbURL,
                allowsSave: true,
                cloudKitDatabase: .none
            )
            
            sharedModelContainer = try ModelContainer(
                for: schema,
                // Пока отключу миграцию. Всё на одном компе. Поэтому не нужно.
//                                migrationPlan: PaymentMigrationPlan.self,
                configurations: [config]
            )
        }catch {
            fatalError("Failed to configure container: \(error)")
        }
    }
    
    
    var body: some Scene {
        @Environment(\.openWindow) var openWindow
        
        WindowGroup {
            TabView(selection: $viewModel.selectedWindowGroupTab) {
                CalendarView(viewModel:viewModel)
                    .tabItem {
                        Label("Календарь", systemImage: "calendar")
                    }
                    .tag(EWindowGroup.calendar)
                MainView(viewModel: viewModel, modelContext: sharedModelContainer.mainContext)
                    .tabItem {
                        Label("Студенты", systemImage: "house")
                    }
                    .tag(EWindowGroup.main)
            }
            .sheet(isPresented: $viewModel.showSheetEditMeeting) {
                if let meeting = viewModel.selectedMeeting{
                    UpdateMeetingView(
                        meeting: meeting,
                        isPresented: $viewModel.showSheetEditMeeting,
                        dataService: StudentsDataService(modelContext: sharedModelContainer.mainContext, viewModel: viewModel)
                    ){}
                }
            }
            .sheet(isPresented: $viewModel.showSheetNewMeeting) {
                if let selectedOrder = viewModel.selectedOrder{
                    let meeting = viewModel.prepareNewMeeting(from: viewModel.selectedMeeting)
                    CreateMeetingView(
                        order: selectedOrder,
                        meeting: meeting,
                        isPresented: $viewModel.showSheetNewMeeting,
                        dataService: StudentsDataService(
                            modelContext: sharedModelContainer.mainContext,
                            viewModel: viewModel
                        )
                    ) {}
                } else {
                    EmptyView() // Обязательно добавь fallback
                }
            }
            .sheet(isPresented: $showSettings){
                PaymentCategoriesView(isPresented: $showSettings)
                    .environment(\.modelContext, sharedModelContainer.mainContext)
            }
            .alert("Путь к БД", isPresented: $showPathDB) {
                Button("Закрыть", role: .cancel) {
                    showPathDB = false
                }
                Button("Перейти"){
                    if let storeURL = storeURL{
                        folderViewModel.openFolder(at: storeURL.deletingLastPathComponent().path)
                    }
                }
            } message: {
                Text(storeURL?.deletingLastPathComponent().path ?? "DB error path")
            }
            .alert(self.error != nil ? "Ошибка":"Бэкап создан", isPresented: $showBackupPathDB) {
                Button("OK", role: .cancel) {
                    showBackupPathDB = false
                }
            } message: {
                if let error = self.error {
                    Text(error.localizedDescription)
                } else {
                    Text(backupURL?.path ?? "DB error no path")
                }
            }
        }
        .modelContainer(sharedModelContainer)
        .commands {
            CommandGroup(after: .appInfo) {
                Divider()
                Button("Данные") {
                    showSettings = true
                }
                Button("База данных") {
                    storeURL = sharedModelContainer.configurations.first?.url
                    showPathDB = true
                }
                Button("Создать бэкап") {
                    do {
                        backupURL = try backupRepository.createBackup()
                        self.error = nil
                    } catch {
                        self.error = error
                    }
                    showBackupPathDB = true
                }
            }
            
            
            
            //            CommandMenu("Students") {
            //                Button("New..."){
            //                    viewModel.showSheetNewStudent = true
            //                }
            //                if let selectedStudent = viewModel.selectedStudent {
            //                    Menu(selectedStudent.name){
            //                        Button("Edit...") {
            //                            viewModel.showSheetEditStudent = true
            //                        }
            //                        Button("Delete") {
            //                            viewModel.showConfirmDeleteStudent = true
            //                        }
            //                        Divider()
            //                        Button("Statistics") {
            //                            viewModel.showSheetStudentStatistics = true
            //                        }
            //                    }
            //                }
            //            }
            //            if viewModel.selectedStudent != nil {
            //                CommandMenu("Orders") {
            //                    Button("New..."){
            //                        viewModel.showSheetNewOrder = true
            //                    }
            //                    if let selectedOrder = viewModel.selectedOrder{
            //                        Menu(selectedOrder.title){
            //                            Button("Edit...") {
            //                                viewModel.showSheetEditOrder = true
            //                            }
            //                            Button("Delete") {
            //                                viewModel.showConfirmDeleteOrder = true
            //                            }
            //                            Divider()
            //                            Button("Statistics") {
            //                                viewModel.showSheetOrderStatistics = true
            //                            }
            //                        }
            //                    }
            //                }
            //            }
            //            if viewModel.selectedOrder != nil {
            //                if viewModel.selectedOrderDetailsTab == .meetings {
            //                    CommandMenu("Schedule") {
            //                        Button("New meeting..."){
            //                            viewModel.showSheetNewMeeting = true
            //                        }
            //                        if let selectedMeeting = viewModel.selectedMeeting{
            //                            Menu(selectedMeeting.details){
            //                                Button("Edit...") {
            //                                    viewModel.showSheetEditMeeting = true
            //                                }
            //                                Button("Delete") {
            //                                    viewModel.showConfirmDeleteMeeting = true
            //                                }
            //                            }
            //                        }
            //                    }
            //                }
            //                if viewModel.selectedOrderDetailsTab == .works {
            //                    CommandMenu("Works") {
            //                        Button("New work..."){
            //                            viewModel.showSheetNewWork = true
            //                        }
            //                        if let selectedWork = viewModel.selectedWork{
            //                            Menu(selectedWork.details){
            //                                Button("Edit...") {
            //                                    viewModel.showSheetEditWork = true
            //                                }
            //                                Button("Delete") {
            //                                    viewModel.showConfirmDeleteWork = true
            //                                }
            //                            }
            //                        }
            //                    }
            //                }
            //                if viewModel.selectedOrderDetailsTab == .payments {
            //                    CommandMenu("Payments") {
            //                        Button("New payment..."){
            //                            viewModel.showSheetNewPayment = true
            //                        }
            //                        if let selectedPayment = viewModel.selectedPayment{
            //                            Menu(selectedPayment.details){
            //                                Button("Edit...") {
            //                                    viewModel.showSheetEditPayment = true
            //                                }
            //                                Button("Delete") {
            //                                    viewModel.showConfirmDeletePayment = true
            //                                }
            //                            }
            //                        }
            //                    }
            //                }
            //            }
        }
    }
}
