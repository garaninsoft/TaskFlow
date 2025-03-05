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
            MainView()
        }
        .modelContainer(sharedModelContainer)
    }
}
