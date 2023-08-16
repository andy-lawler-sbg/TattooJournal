//
//  HomeView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI
import TipKit

struct HomeHelperViewItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
}

struct HomeView: View {

    @EnvironmentObject var appointments: Appointments
    @Bindable var viewModel = HomeViewModel()

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
                TipView(homeTip, arrowEdge: .bottom)
                    .tipBackground(Color.white)
                    .padding(.horizontal)
                    .padding(.top, 7.5)

                ScrollView(.horizontal) {
                    HStack {
                        ForEach(helperViewItems) { item in
                            VStack(spacing: 20) {
                                Text(item.title)
                                    .font(.callout).bold()
                                Text(item.description)
                                    .font(.caption2)
                                    .multilineTextAlignment(.center)
                            }
                            .foregroundStyle(.white)
                            .padding()
                            .background(Color.accentColor)
                        }
                    }
                }
                .scrollIndicators(.hidden)

                List {
                    if appointments.hasAppointments {
                        AppointmentCell(appointment: appointments.nextAppointment()!)
                            .listRowSeparator(.hidden)
                            .onTapGesture {
                                viewModel.shouldShowAppointmentForm = true
                            }
                            .listRowBackground(Color.clear)
                    }
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)

            }
            .background(Color.gray.opacity(0.1))
            .navigationTitle(Constants.title)
            .toolbar {
                Button {
                    viewModel.shouldShowSettingsScreen = true
                } label: {
                    NavBarItem(imageName: Constants.ImageNames.settings)
                }
                .onTapGesture(perform: Haptics.shared.successHaptic)
            }
        }
        .sheet(isPresented: $viewModel.shouldShowAppointmentForm) {
            AppointmentForm(isShowingAppointmentForm: $viewModel.shouldShowAppointmentForm,
                            viewModel: AppointmentFormViewModel(appointment: appointments.nextAppointment()))
        }
        .sheet(isPresented: $viewModel.shouldShowSettingsScreen) {
            SettingsView(isShowingSettingsView: $viewModel.shouldShowSettingsScreen)
        }
    }
}

extension HomeView {
    enum Constants {
        static let title = "🏠 Home"
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
