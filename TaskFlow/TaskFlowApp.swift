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
    
    @StateObject var viewModel = MainViewModel()
    
    @State private var showPaymentCategory: Bool = false
    @State private var showSettings: Bool = false
    @State private var showPathDB: Bool = false
    @State private var showBackupPathDB: Bool = false
    
    private let backupRepository = BackupRepository()
    @State private var backupURL: URL?
    @State private var error: Error?
    @State private var storeURL: URL?
    
    @StateObject private var folderViewModel = FolderViewModel()
    
    @StateObject private var settings = AppSettings.shared
    
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
            .onAppear{
                if !settings.isConfigured {
                    showSettings = true
                }
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
                SettingsView(isPresented: $showSettings)
            }
            .sheet(isPresented: $showPaymentCategory){
                PaymentCategoriesView(isPresented: $showPaymentCategory)
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
                Button("Статьи расхода") {
                    showPaymentCategory = true
                }
                Button("Настройка") {
                    showSettings = true
                }
                Divider()
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
        }
    }
}
