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
                PathPickerView(
                    path: $settings.dbPath,
                    folderURL: $dbPathURL,
                    title: "Путь к БД"
                )
                
                TextField("Имя бэкап", text: $settings.dbBackupName).textFieldStyle(.roundedBorder)
                PathPickerView(
                    path: $settings.dbBackupPath,
                    folderURL: $dbBackupPathURL,
                    title: "Путь к бэкап"
                )
                
            } header: {
                Text("База данных")
                    .font(.headline)
            }
            
            Section {
                PathPickerView(
                    path: $settings.rootOrdersPath,
                    folderURL: $rootOrdersPathURL,
                    title: "Путь к Заказам"
                )
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
}
