//
//  TattooJournalApp.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI
import SwiftData
import TipKit

@main
struct TattooJournalApp: App {

    @AppStorage(Constants.AppStorage.shouldShowOnboarding) private var shouldShowOnboarding = true
    
    var userPreferences = UserPreferences()

    var body: some Scene {
        WindowGroup {
            ZStack {
                TJTabView(isShowingOnboarding: $shouldShowOnboarding)
                    .environmentObject(userPreferences)
                if shouldShowOnboarding {
                    OnboardingView(isShowingOnboarding: $shouldShowOnboarding)
                }
            }
            .task {
                try? Tips.configure([.displayFrequency(.immediate), .datastoreLocation(.applicationDefault)])
            }
        }
        .modelContainer(for: [Appointment.self, Artist.self, Shop.self])
    }
}

extension TattooJournalApp {
    enum Constants {
        enum AppStorage {
            static let shouldShowOnboarding = "shouldShowOnboarding"
            static let shouldShowNotificationPermissions = "shouldShowNotificationPermissions"
        }
    }
}
