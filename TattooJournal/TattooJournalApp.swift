//
//  TattooJournalApp.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI
import SwiftData
import TipKit
import Combine

@main
struct TattooJournalApp: App {

    @AppStorage(Constants.AppStorage.shouldShowOnboarding) private var shouldShowOnboarding = true

    var themeHandler = AppThemeHandler()
    var notificationsHandler = NotificationsHandler()
    var appEventHandler = AppEventHandler()

    var body: some Scene {
        WindowGroup {
            ZStack {
                TJTabView(isShowingOnboarding: $shouldShowOnboarding)
                    .environmentObject(themeHandler)
                    .environmentObject(notificationsHandler)
                    .environmentObject(appEventHandler)
                if shouldShowOnboarding {
                    OnboardingView(isShowingOnboarding: $shouldShowOnboarding)
                }
            }
            .task {
                try? Tips.configure([.displayFrequency(.immediate), .datastoreLocation(.applicationDefault)])
            }
            .preferredColorScheme(themeHandler.colorScheme)
        }
        .modelContainer(for: [Appointment.self, Artist.self, Shop.self, UserPreferences.self])
    }
}

private extension TattooJournalApp {
    enum Constants {
        enum AppStorage {
            static let shouldShowOnboarding = "shouldShowOnboarding"
        }
    }
}

final class AppEventHandler: ObservableObject {
    let eventPublisher = PassthroughSubject<AppEvent, Never>()

    enum AppEvent {
        case addAppointment
    }
}
