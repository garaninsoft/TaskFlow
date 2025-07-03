//
//  SettingsForm.swift
//  TaskFlow
//
//  Created by alexandergaranin on 03.07.2025.
//

import SwiftUI

struct SettingsView: View {
    @Binding var isPresented: Bool
    
    @AppStorage("isNotificationsEnabled") private var isNotificationsEnabled = true
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    @AppStorage("selectedTheme") private var selectedTheme = "Системная"
    @AppStorage("volumeLevel") private var volumeLevel: Double = 50
    @AppStorage("username") private var username = ""
    @AppStorage("selectedLanguage") private var selectedLanguage = "Русский"
    
    private let themes = ["Системная", "Светлая", "Тёмная"]
    private let languages = ["Русский", "Английский", "Испанский", "Французский"]
    
    var body: some View {
        Form {
            // Секция персональных данных
            Section {
                TextField("Имя пользователя", text: $username)
                    .textFieldStyle(.roundedBorder)
                
                DatePicker(
                    "Дата рождения",
                    selection: .constant(Date()),
                    displayedComponents: .date
                )
            } header: {
                Text("Персональные данные")
                    .font(.headline)
            }
            
            // Секция внешнего вида
            Section {
                Toggle("Тёмный режим", isOn: $darkModeEnabled)
                    .toggleStyle(.switch)
                
                Picker("Тема:", selection: $selectedTheme) {
                    ForEach(themes, id: \.self) { theme in
                        Text(theme)
                    }
                }
                .pickerStyle(.radioGroup)
                
                Picker("Язык:", selection: $selectedLanguage) {
                    ForEach(languages, id: \.self) { language in
                        Text(language)
                    }
                }
            } header: {
                Text("Внешний вид")
                    .font(.headline)
            }
            
            // Секция уведомлений
            Section {
                Toggle("Уведомления", isOn: $isNotificationsEnabled)
                    .toggleStyle(.switch)
                
                if isNotificationsEnabled {
                    VStack(alignment: .leading) {
                        Text("Громкость уведомлений: \(Int(volumeLevel))%")
                        Slider(
                            value: $volumeLevel,
                            in: 0...100,
                            step: 5
                        ) {
                            Text("Громкость")
                        } minimumValueLabel: {
                            Text("0%")
                        } maximumValueLabel: {
                            Text("100%")
                        }
                    }
                    .padding(.top, 4)
                }
            } header: {
                Text("Уведомления")
                    .font(.headline)
            }
            
            // Секция действий
            Section {
                HStack {
                    Button("Сбросить") {
                        resetSettings()
                        isPresented = false
                    }
                    
                    Spacer()
                    
                    Button("Сохранить") {
                        saveSettings()
                        isPresented = false
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.vertical, 8)
            }
        }
        .formStyle(.grouped)
        .frame(minWidth: 500, idealWidth: 600, maxWidth: .infinity,
               minHeight: 400, idealHeight: 500, maxHeight: .infinity)
        .padding()
        .navigationTitle("Настройки")
    }
    
    private func resetSettings() {
        isNotificationsEnabled = true
        darkModeEnabled = false
        selectedTheme = "Системная"
        volumeLevel = 50
        username = ""
        selectedLanguage = "Русский"
    }
    
    private func saveSettings() {
        // Реальная логика сохранения настроек
        print("Настройки сохранены")
        NSApp.sendAction(#selector(NSWindow.close), to: nil, from: nil)
    }
}
