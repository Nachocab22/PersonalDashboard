//
//  PersonalDashboardApp.swift
//  PersonalDashboard
//
//  Created by Nachete on 20/06/2026.
//

import SwiftUI
import SwiftData

@main
struct PersonalDashboardApp: App {
    private let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            TaskItem.self,
            Habit.self,
            HabitCompletion.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
