//
//  HomeView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI
import SwiftData

struct HomeView: View {

    @Bindable var viewModel = HomeViewModel()

    @Query(
        sort: \Appointment.date,
        order: .forward
    ) private var queriedAppointments: [Appointment]

    @Query private var artists: [Artist]
    
    var body: some View {
        NavigationStack {
            VStack {
                if queriedAppointments.count >= 2 {
                    spendingChart
                }
                Spacer()
            }
            .background(Color(.background))
            .navigationTitle(Constants.title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation {
                            viewModel.shouldShowSettingsScreen = true
                        }
                    } label: {
                        NavBarItem(imageName: Constants.ImageNames.settings)
                    }
                    .onTapGesture(perform: Haptics.shared.successHaptic)
                }
            }
        }
        .sheet(isPresented: $viewModel.shouldShowSettingsScreen) {
            SettingsView()
        }
    }

    private var spendingChart: some View {
        AppointmentSpendingChart(viewModel: .init(appointments: queriedAppointments))
    }

    private var artistsCollectionView: some View {
        ArtistsCollectionView(viewModel: .init(artists: artists))
    }
}

extension HomeView {
    enum Constants {
        static let title = "Home"
        enum ImageNames {
            static let settings = "gear"
        }
    }
}

#Preview("Home Screen") {
    TabView {
        HomeView()
            .tabItem {
                Label("Home", systemImage: "house")
            }
            .environmentObject(AppThemeHandler())
    }
}
