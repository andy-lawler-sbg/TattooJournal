//
//  HomeView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI
import SwiftData
import TipKit

struct HomeHelperViewItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
}

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

    var homeTip = HomeTip()

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    let helperViewItems: [HomeHelperViewItem] = [
        .init(title: "Add Appointments", description: "You don't have any appointments, maybe add some?"),
        .init(title: "Add Appointments", description: "Add some appointments :)"),
        .init(title: "Add Appointments", description: "Add some appointments :)"),
        .init(title: "Add Appointments", description: "Add some appointments :)")
    ]

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
            SettingsView(isShowingSettingsView: $viewModel.shouldShowSettingsScreen)
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

struct NavBarItem: View {

    @State private var symbolAnimationValue = 10
    var imageName: String

    var body: some View {
        ZStack {
            Circle()
                .frame(width: 35, height: 35)
                .foregroundStyle(Color(.cellBackground))
            Image(systemName: imageName)
                .imageScale(.medium)
                .frame(width: 60, height: 60)
                .foregroundColor(.secondary)
                .bold()
                .symbolEffect(.pulse, value: symbolAnimationValue)
        }
    }
}

#Preview("Nav Bar Button") {
    ZStack {
        Color.gray.opacity(0.1)
        NavBarItem(imageName: "gear")
    }
}

#Preview("Home Screen") {
    TabView {
        HomeView()
            .tabItem {
                Label("Home", systemImage: "house")
            }
            .modifier(PreviewEnvironmentObjects())
    }
}
