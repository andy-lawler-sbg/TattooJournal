//
//  TattooJournalApp.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI

@main
struct TattooJournalApp: App {

    var appointments = Appointments()
    var userPreferences = UserPreferences()

    let shouldShowOnboarding = false

    var body: some Scene {
        WindowGroup {
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
    }
}
