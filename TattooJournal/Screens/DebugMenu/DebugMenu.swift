//
//  DebugMenu.swift
//  TattooJournal
//
//  Created by Andy Lawler on 06/08/2023.
//

import SwiftUI

struct DebugMenu: View {

    @Binding var isShowingDebugMenu: Bool
    @AppStorage(TattooJournalApp.Constants.AppStorage.shouldShowOnboarding) private var shouldShowOnboarding = false
    @AppStorage(TattooJournalApp.Constants.AppStorage.shouldShowNotificationPermissions) private var shouldShowNotificationPermissions = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle("Show Onboarding Flow", isOn: $shouldShowOnboarding)
                } header: {
                    Text("Onboarding")
                } footer: {
                    Text("Turn on switches relating to the onboarding flow of the app.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                Section {
                    Toggle("Show Notification Permissions", isOn: $shouldShowNotificationPermissions)
                } header: {
                    Text("Notifications")
                } footer: {
                    Text("Turn on notification related switches.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .formStyle(.grouped)
            .navigationTitle("Debug Menu")
        }
        .tint(.accentColor)
        .overlay(Button {
            isShowingDebugMenu = false
        } label: {
            XMarkButton()
        }, alignment: .topTrailing)
    }
}
