//
//  TattooJournalApp.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI
import TipKit

@main
struct TattooJournalApp: App {

    var appointments = Appointments()

    var userPreferences = UserPreferences()

    @AppStorage(Constants.AppStorage.shouldShowOnboarding) private var shouldShowOnboarding = false

    var body: some Scene {
        WindowGroup {
            ZStack {
                if shouldShowOnboarding {
                    OnboardingView {
                        TJTabView()
                            .environmentObject(appointments)
                            .environmentObject(userPreferences)
                    }
                } else {
                    TJTabView()
                        .environmentObject(appointments)
                        .environmentObject(userPreferences)
                }
            }
            .task {
                // Configure and load your tips at app launch.
                try? await Tips.configure {
                    DisplayFrequency(.immediate)
                    DatastoreLocation(.applicationDefault)
                }
            }
        }
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
