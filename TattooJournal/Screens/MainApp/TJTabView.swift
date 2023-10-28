//
//  TJTabView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI
import SwiftData

struct TJTabView: View {

    // MARK: - Environment

    @EnvironmentObject private var themeHandler: AppThemeHandler
    @EnvironmentObject private var notificationsHandler: NotificationsHandler
    @Environment(\.modelContext) var context

    // MARK: - Onboarding & Initial Setup

    @Binding var isShowingOnboarding: Bool
    @Query var queriedUserPreferences: [UserPreferences]
    
    // MARK: - Review

    @Environment(\.scenePhase) private var scenePhase
    @Query(sort: \Appointment.date,
           order: .forward
    ) var queriedAppointments: [Appointment]
    @State var shouldShowAppointmentReviewPage = false

    // MARK: - DeepLinks

    @State private var selectedPage = 1

    var body: some View {
        TabView(selection: $selectedPage) {
            HomeView(selectedPage: $selectedPage)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(1)
            AppointmentsView()
                .tabItem {
                    Label("Appointments", systemImage: "list.clipboard.fill")
                }
                .tag(2)
            HistoryView(selectedPage: $selectedPage)
                .tabItem {
                    Label("History", systemImage: "doc.badge.clock")
                }
                .tag(3)
        }
        .tint(themeHandler.appColor)
        .sheet(isPresented: $shouldShowAppointmentReviewPage, onDismiss: {
            UserDefaults.standard.removeObject(forKey: Constants.lastClosedAppKey)
        }) {
            if let filtered {
                ReviewAppointmentView(viewModel: .init(appointments: filtered))
            }
        }
        .task {
            await setupUserPreferences()
        }
        .onAppear {
            notificationsHandler.requestAuthorization()
        }
        .onChange(of: scenePhase) {
            if scenePhase == .background {
                appDidEnterBackground()
            } else if scenePhase == .active {
                appDidEnterForeground()
            }
        }
    }
}


#Preview {
    /// `isShowingOnboarding = true` allows the permissions view to not show
    TJTabView(isShowingOnboarding: .constant(false))
        .environmentObject(AppThemeHandler())
}
