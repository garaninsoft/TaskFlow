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
    @StateObject private var folderViewModel = FolderViewModel()
    @StateObject private var settings = AppSettings.shared
    
    @State private var modelContainer: ModelContainer?
    
    @State private var showPaymentCategory: Bool = false
    @State private var showSettings: Bool = false
    @State private var showPathDB: Bool = false
    @State private var showBackupPathDB: Bool = false
    @State private var backupURL: URL?
    @State private var error: Error?
    @State private var storeURL: URL?
    
    private let backupRepository = BackupRepository()
    
    let schema = Schema([
        PaymentCategory.self,
        Order.self,
        Payment.self,
        Schedule.self,
        Student.self,
        Work.self
    ])
    
    private func initModelContainer() {
        guard settings.isConfigured else { return }
        
        do {
            let dbURL = URL(filePath: settings.dbPath.appending(settings.dbName))
            let config = ModelConfiguration(schema: schema, url: dbURL, allowsSave: true)
            modelContainer = try ModelContainer(for: schema, configurations: [config])
        } catch {
            print("Ошибка инициализации контейнера: \(error)")
            modelContainer = nil
        }
    }
    
    var body: some Scene {
        @Environment(\.openWindow) var openWindow
        
        WindowGroup {
            Group {
                if let container = modelContainer {
                    TabView(selection: $viewModel.selectedWindowGroupTab) {
                        CalendarView(viewModel:viewModel)
                            .tabItem {
                                Label("Календарь", systemImage: "calendar")
                            }
                            .tag(EWindowGroup.calendar)
                        
                        MainView(viewModel: viewModel, modelContext: container.mainContext)
                            .tabItem {
                                Label("Студенты", systemImage: "house")
                            }
                            .tag(EWindowGroup.main)
                    }
                    .environment(\.modelContext, container.mainContext)
                    .sheet(isPresented: $viewModel.showSheetEditMeeting) {
                        if let meeting = viewModel.selectedMeeting {
                            UpdateMeetingView(
                                meeting: meeting,
                                isPresented: $viewModel.showSheetEditMeeting,
                                dataService: StudentsDataService(modelContext: container.mainContext, viewModel: viewModel)
                            ) {}
                        }
                    }
                    .sheet(isPresented: $viewModel.showSheetNewMeeting) {
                        if let selectedOrder = viewModel.selectedOrder {
                            let meeting = viewModel.prepareNewMeeting(from: viewModel.selectedMeeting)
                            CreateMeetingView(
                                order: selectedOrder,
                                meeting: meeting,
                                isPresented: $viewModel.showSheetNewMeeting,
                                dataService: StudentsDataService(modelContext: container.mainContext, viewModel: viewModel)
                            ) {}
                        } else {
                            EmptyView()
                        }
                    }
                    .sheet(isPresented: $showPaymentCategory){
                        PaymentCategoriesView(isPresented: $showPaymentCategory)
                            .environment(\.modelContext, container.mainContext)
                    }
                    .alert("Путь к БД", isPresented: $showPathDB) {
                        Button("Закрыть", role: .cancel) {
                            showPathDB = false
                        }
                        Button("Перейти"){
                            if let storeURL = storeURL {
                                folderViewModel.openFolder(at: storeURL.deletingLastPathComponent().path)
                            }
                        }
                    } message: {
                        Text(storeURL?.deletingLastPathComponent().path ?? "DB error path")
                    }
                    .alert(self.error != nil ? "Ошибка" : "Бэкап создан", isPresented: $showBackupPathDB) {
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
                } else {
                    ProgressView("Загрузка...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onAppear {
                            if !settings.isConfigured {
                                showSettings = true
                            } else {
                                initModelContainer()
                            }
                        }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(isPresented: $showSettings)
            }
        }
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
                    storeURL = modelContainer?.configurations.first?.url
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
