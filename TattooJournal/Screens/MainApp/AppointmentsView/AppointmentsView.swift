//
//  AppointmentsView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI
import TipKit

struct AppointmentsView: View {

    @EnvironmentObject var appointments: Appointments
    @EnvironmentObject var userPreferences: UserPreferences

    @Bindable var viewModel = AppointmentsViewModel()

    var appointmentsTip = AppointmentsTip()

    var body: some View {
        NavigationStack {
            ZStack {
                if appointments.hasAppointments {
                    VStack {
                        TipView(appointmentsTip, arrowEdge: .bottom)
                            .tipBackground(Color.white)
                            .padding(.horizontal)
                            .padding(.top, 7.5)
                        List {
                            ForEach(appointments.orderedAppointments) { appointment in
                                AppointmentCell(appointment: appointment)
                                    .listRowSeparator(.hidden)
                                    .onTapGesture {
                                        viewModel.shouldShowAppointmentsForm = true
                                        viewModel.selectedAppointment = appointment
                                    }
                            }.onDelete { indexSet in
                                appointments.delete(context: .ordered, indexSet)
                            }
                            .listRowBackground(Color.clear)
                        }
                        .listStyle(.plain)
                        .scrollIndicators(.hidden)

                        AppointmentsCollapsible(collapsedTotal: $viewModel.collapsedTotal)
                            .padding(.vertical, viewModel.collapsedTotal ? 5 : 10)

                        Spacer()
                    }
                } else {
                    EmptyState(imageName: Constants.EmptyState.title,
                               title: Constants.EmptyState.title,
                               description: Constants.EmptyState.description)
                }
            }
            .background(Color.gray.opacity(0.1))
            .navigationTitle(Constants.title)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.shouldShowAppointmentsForm = true
                        viewModel.selectedAppointment = nil
                    } label: {
                        NavBarItem(imageName: Constants.ImageNames.add)
                    }
                    .onTapGesture(perform: Haptics.shared.successHaptic)
                }
            }
        }
        .sheet(isPresented: $viewModel.shouldShowAppointmentsForm) {
            AppointmentForm(isShowingAppointmentForm: $viewModel.shouldShowAppointmentsForm,
                            viewModel: AppointmentFormViewModel(appointment: viewModel.selectedAppointment))
        }
    }
}

private extension AppointmentsView {
    enum Constants {
        static let title = "🗓️ Appointments"

        enum ImageNames {
            static let add = "plus"
        }

        enum EmptyState {
            static let imageName = "bookmark.slash"
            static let title = "No Appointments"
            static let description = "You should add some appointments."
        }
    }
}

#Preview {
    TabView {
        AppointmentsView()
            .tabItem {
                Label("Appointments", systemImage: "book")
            }
            .modifier(PreviewEnvironmentObjects())
    }
}
