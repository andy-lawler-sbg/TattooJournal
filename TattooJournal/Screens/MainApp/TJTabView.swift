//
//  TJTabView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI
import UserNotifications

struct TJTabView: View {

    @State var showDebugMenu = false
    @State var showNotificationPermissionsScreen = false

    @EnvironmentObject var userPreferences: UserPreferences
    @AppStorage(TattooJournalApp.Constants.AppStorage.shouldShowNotificationPermissions) private var shouldShowNotificationPermissions = false

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .onShake {
                    #if DEBUG
                    showDebugMenu = true
                    #endif
                }
            AppointmentsView()
                .tabItem {
                    Label("Appointments", systemImage: "book")
                }
                .onShake {
                    #if DEBUG
                    showDebugMenu = true
                    #endif
                }
            PastTattoosView()
                .tabItem {
                    Label("Past Tattoos", systemImage: "pencil.line")
                }
                .onShake {
                    #if DEBUG
                    showDebugMenu = true
                    #endif
                }
                .onShake {
                    #if DEBUG
                    showDebugMenu = true
                    #endif
                }
            PersonalView()
                .tabItem {
                    Label("Personal", systemImage: "person.fill")
                }
        }
        .tint(userPreferences.appColor)
        .sheet(isPresented: $showDebugMenu) {
            DebugMenu(isShowingDebugMenu: $showDebugMenu)
        }
        .sheet(isPresented: $showNotificationPermissionsScreen) {
            NotificationPermissions(showNotificationPermissions: $showNotificationPermissionsScreen)
        }
        .onAppear {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                if shouldShowNotificationPermissions {
                    showNotificationPermissionsScreen = true
                    return
                }

                switch settings.authorizationStatus {
                case .notDetermined:
                    showNotificationPermissionsScreen = true
                case .authorized, .provisional, .denied, .ephemeral:
                  return
                @unknown default:
                    return
                }
            }
        }
    }
}

#Preview {
    TJTabView()
        .modifier(PreviewEnvironmentObjects())
}
