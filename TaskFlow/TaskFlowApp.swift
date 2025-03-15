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
    
    init() {
        // Заменяем названия после запуска приложения
        // todo: норм не работает: если изменять пункты меню, то идёт возврат удалённых элементов
        // deleteStandartMenu()
        
    }

    private func deleteStandartMenu(){
        DispatchQueue.main.async {
            // Получаем главное меню
            guard let mainMenu = NSApplication.shared.mainMenu else { return }

            let titleMenusForDelete = ["File", "Edit", "View", "Window", "Help"]
            titleMenusForDelete.forEach{ title in
                if let menu = mainMenu.item(withTitle: title){
                    mainMenu.removeItem(menu)
                }
            }
        }
    }
    
    @State private var selectedStudent: Student? = nil
    @State private var selectedOrder: Student? = nil
    
    @State private var showSheetNewStudent: Bool = false
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Student.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    // Получаем общий контекст модели
    var sharedModelContext: ModelContext? {
        guard let modelContainer = try? ModelContainer(for: Student.self) else {
            return nil
        }
        return ModelContext(modelContainer)
    }

    var body: some Scene {
        @Environment(\.openWindow) var openWindow
        
        WindowGroup {
            MainView(
                selectedStudent: $selectedStudent,
                showSheetNewStudent: $showSheetNewStudent
            )
        }
        .modelContainer(sharedModelContainer)
        .commands {

            CommandMenu("Students") {
                Button("New..."){
                    showSheetNewStudent.toggle()
                }
                
                if let selectedStudent = selectedStudent {
                    
                    Menu(selectedStudent.name){
                        Button("Edit..") {
                           
                        }
                        Button("Delete") {
                            print("Action 1 triggered")
                        }
                    }
                }
            }
            
            
            
//            // Заменяем стандартное меню "File" на "Проект"
//            CommandGroup(replacing: .newItem) {
//                Button("Новый проект") {
//                    print("Новый проект создан")
//                }
//                .keyboardShortcut("n", modifiers: [.command])
//                
//                Button("Открыть проект") {
//                    print("Проект открыт")
//                }
//                .keyboardShortcut("o", modifiers: [.command])
//                
//                Button("Сохранить проект") {
//                    print("Проект сохранен")
//                }
//                .keyboardShortcut("s", modifiers: [.command])
//            }

            // Пример использования selection
//            if let selectedStudent = selectedStudent {
//                CommandGroup(before: .undoRedo) { // Добавим перед Undo/Redo
//                    Button("Delete Item \(selectedStudent.name)") {
//                        print("Deleting Item \(selectedStudent.name)")
//                        self.selectedStudent = nil // Сбросим выбор
//                    }
//                    .keyboardShortcut(.delete, modifiers: []) // Просто Delete
//                }
//            }
        }

    }
    
}
