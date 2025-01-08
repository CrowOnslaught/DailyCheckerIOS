//
//  DailyCheckerApp.swift
//  DailyChecker
//
//  Created by Jaume García on 7/1/25.
//

import SwiftUI
import SwiftData

@main
struct DailyCheckerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
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
            NavigationStack {
                ContentView()
                    .onAppear() {
                        let center = UNUserNotificationCenter.current()
                        center.requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
                        if let error = error {
                            // Handle the error here.
                        }
                        // Enable or disable features based on the authorization.
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .modelContainer(sharedModelContainer)
    }
}
