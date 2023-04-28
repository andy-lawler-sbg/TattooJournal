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
                Text(Constants.description)
                    .multilineTextAlignment(.center)
                    .padding()
                    .font(.caption)
                    .foregroundColor(.secondary)
                if appointments.hasAppointments {
                    List {
                        Section {
                            AppointmentCell(appointment: appointments.nextAppointment()!)
                                .onTapGesture {
                                    viewModel.shouldShowAppointmentForm = true
                                }
                                .listRowSeparator(.hidden)
                        } header: {
                            Text(Constants.Headers.nextAppointment)
                        }
                        Section {
                            GetWhatYouGetBanner()
                                .onTapGesture {
                                    viewModel.shouldShowGetWhatYouGet = true
                                }
                                .listRowSeparator(.hidden)
                        } header: {
                            Text(Constants.Headers.getWhatYouGet)
                        }
                    }
                    .listStyle(.plain)
                    .padding(.top, -20)
                    CostView()
                        .padding(.bottom, 40)
                }
                Spacer()
            }
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
        .sheet(isPresented: $viewModel.shouldShowGetWhatYouGet) {
            GetWhatYouGet(isShowingGetWhatYouGet: $viewModel.shouldShowGetWhatYouGet)
        }
    }
}

extension HomeView {
    enum Constants {
        static let title = "🖌️ Tattoo Journal"
        static let description = "Welcome to Tattoo Journal. Here you can track your tattoo appointments, view past appointments and the work you had done. You also can view the amount you have spent on your tattoos."

        enum Headers {
            static let nextAppointment = "Next Appointment"
            static let getWhatYouGet = "Get What You Get"
        }

        enum ImageNames {
            static let settings = "gear"
        }
    }
}

struct NavBarItem: View {
    var imageName: String

    var body: some View {
        ZStack {
            Circle()
                .frame(width: 40, height: 40)
                .foregroundColor(.primary).opacity(0.2)
                .opacity(0.2)
            Image(systemName: imageName)
                .imageScale(.medium)
                .frame(width: 54, height: 54)
                .foregroundColor(.secondary)
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
