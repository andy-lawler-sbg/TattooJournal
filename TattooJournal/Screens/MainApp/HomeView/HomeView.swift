//
//  HomeView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI

struct HomeView: View {

    @EnvironmentObject var appointments: Appointments
    @StateObject var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                if appointments.hasAppointments {
                    AppointmentCell(appointment: appointments.nextAppointment()!)
                        .onTapGesture {
                            viewModel.shouldShowAppointmentForm = true
                        }
                        .padding()
                }
            }
            .background(Color.gray.opacity(0.1))
            .navigationTitle(Constants.title)
            .toolbar {
                Button {
                    viewModel.shouldShowSettingsScreen = true
                } label: {
                    NavBarItem(imageName: Constants.ImageNames.settings)
                }
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
                .frame(width: 40, height: 40)
                .foregroundStyle(Color(.cellBackground))
                .shadow(color: .black.opacity(0.05), radius: 5, y: 3)
            Image(systemName: imageName)
                .imageScale(.medium)
                .frame(width: 60, height: 60)
                .foregroundColor(.secondary)
                .symbolEffect(.pulse, value: symbolAnimationValue)
        }
    }
}

struct HomeView_Previews: PreviewProvider {

    static var previews: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .modifier(PreviewEnvironmentObjects())
        }
    }
}
