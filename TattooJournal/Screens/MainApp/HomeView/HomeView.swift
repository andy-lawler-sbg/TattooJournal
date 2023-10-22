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

    var nextAppointment: Appointment? {
        let startDate: Date = Date()
        return queriedAppointments.filter({ $0.date >= startDate }).first
    }

    var body: some View {
        NavigationStack {
            VStack {
                if let nextAppointment {
                    List {
                        AppointmentCell(viewModel: .init(appointment: nextAppointment))
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .scrollIndicators(.hidden)
                    .listRowSpacing(-5)
                }

            }
            .background(Color.gray.opacity(0.1))
            .navigationTitle(Constants.title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.shouldShowSettingsScreen = true
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
            .environmentObject(UserPreferences())
    }
}
