//
//  TJTabView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI
import SwiftData

struct TJTabView: View {
    
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var themeHandler: AppThemeHandler

    @Binding var isShowingOnboarding: Bool
    @Query private var queriedUserPreferences: [UserPreferences]

    @State private var selectedPage = 1

    var body: some View {
        TabView(selection: $selectedPage) {
            HomeView()
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
        .task {
            await setupUserPreferences()
        }
        .tint(themeHandler.appColor)
    }

    private func setupUserPreferences() async {
        guard queriedUserPreferences.count < 1 else { return }
        let userPreferences = UserPreferences(currencyString: CurrencyType.sterling.rawValue,
                                              tipAmountString: TipAmountType.tenPercent.rawValue)
        context.insert(userPreferences)
        try? context.save()
    }
}

#Preview {
    /// `isShowingOnboarding = true` allows the permissions view to not show
    TJTabView(isShowingOnboarding: .constant(false))
        .environmentObject(AppThemeHandler())
}
