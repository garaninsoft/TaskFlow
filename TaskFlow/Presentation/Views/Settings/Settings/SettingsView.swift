//
//  SettingsForm.swift
//  TaskFlow
//
//  Created by alexandergaranin on 03.07.2025.
//

import SwiftUI

struct SettingsView: View {
    @Binding var isPresented: Bool
    
    @ObservedObject private var settings = AppSettings.shared
    
    @State private var dbPathURL: URL?
    @State private var dbBackupPathURL: URL?
    @State private var rootOrdersPathURL: URL?
    
    @State private var showValidError: Bool = false
    
    var body: some View {
        Form {
            Section {
                TextField("Имя БД", text: $settings.dbName).textFieldStyle(.roundedBorder)
                HStack{
                    TextField("Путь к БД", text: $settings.dbPath)
                        .textFieldStyle(.roundedBorder)
                    Button("Выбор папки"){
                        FolderPicker(folderURL: $dbPathURL).pickFolder()
                        if let dbPathURL {
                            settings.dbPath = dbPathURL.relativePath + "/"
                        }
                    }
                }
                TextField("Имя бэкап", text: $settings.dbBackupName).textFieldStyle(.roundedBorder)
                HStack{
                    TextField("Путь к бэкап", text: $settings.dbBackupPath)
                        .textFieldStyle(.roundedBorder)
                    Button("Выбор папки"){
                        FolderPicker(folderURL: $dbBackupPathURL).pickFolder()
                        if let dbBackupPathURL {
                            settings.dbBackupPath = dbBackupPathURL.relativePath + "/"
                        }
                    }
                }
            } header: {
                Text("База данных")
                    .font(.headline)
            }
            
            Section {
                HStack{
                    TextField("Путь к Заказам", text: $settings.rootOrdersPath)
                        .textFieldStyle(.roundedBorder)
                    Button("Выбор папки"){
                        FolderPicker(folderURL: $rootOrdersPathURL).pickFolder()
                        if let rootOrdersPathURL {
                            settings.rootOrdersPath = rootOrdersPathURL.relativePath
                        }
                    }
                }
            } header: {
                Text("Заказы")
                    .font(.headline)
            }
            
            Section {
                HStack {
                    Button("Сбросить") {
                        resetSettings()
                    }
                    
                    Spacer()
                    
                    Button("Сохранить") {
                        if(settings.isConfigured){
                            saveSettings()
                            isPresented = false
                        }else{
                            showValidError = true
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.vertical, 8)
            }
        }
        .alert("Ошибка", isPresented: $showValidError) {
            Button("OK", role: .cancel) {
                showValidError = false
            }
        } message: {
            Text("Пропущены обязательные параметры")
        }
        .formStyle(.grouped)
        .frame(minWidth: 500, idealWidth: 600, maxWidth: .infinity,
               minHeight: 400, idealHeight: 500, maxHeight: .infinity)
        .padding()
    }
    
    private func resetSettings() {
        settings.reset()
    }
    
    private func saveSettings() {
        NSApp.sendAction(#selector(NSWindow.close), to: nil, from: nil)
    }
    
    struct FolderPicker: NSViewRepresentable {
        @Binding var folderURL: URL?

        func makeNSView(context: Context) -> some NSView {
            let view = NSView()
            return view
        }

        func updateNSView(_ nsView: NSViewType, context: Context) {}

        func pickFolder() {
            let panel = NSOpenPanel()
            panel.canChooseFiles = false
            panel.canChooseDirectories = true
            panel.allowsMultipleSelection = false

            if panel.runModal() == .OK {
                folderURL = panel.urls.first
            }
        }
    }
}
