//
//  TJTabView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI
import UserNotifications

struct TJTabView: View {

    @EnvironmentObject var userPreferences: UserPreferences
    @Binding var isShowingOnboarding: Bool

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            AppointmentsView()
                .tabItem {
                    Label("Appointments", systemImage: "pencil.and.list.clipboard")
                }
            PastTattoosView()
                .tabItem {
                    Label("Past Tattoos", systemImage: "doc.badge.clock")
                }
        }
        .tint(userPreferences.appColor)
    }
}

#Preview {
    /// `isShowingOnboarding = true` allows the permissions view to not show
    TJTabView(isShowingOnboarding: .constant(true))
        .modifier(PreviewEnvironmentObjects())
}
