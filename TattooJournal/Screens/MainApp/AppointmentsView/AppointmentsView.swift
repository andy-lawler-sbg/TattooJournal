//
//  AppointmentsView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI
import TipKit

/// Appointments View to show the scheduled appointments a User has.
struct AppointmentsView: View {

    @EnvironmentObject var appointments: Appointments
    @EnvironmentObject var userPreferences: UserPreferences

    @Bindable var viewModel = AppointmentsViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    tipView
                    if appointments.hasAppointments {
                        appointmentsView
                    } else {
                        emptyStateView
                    }
                }
            }
            .background(Color(.background))
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
                            viewModel: AppointmentFormViewModel(
                                appointment: viewModel.selectedAppointment)
            )
        }
    }

    // MARK: - Tip View

    /// Tip view which shows users how to use the page.
    private var tipView: some View {
        TipView(AppointmentsTip(hasAppointments: appointments.hasAppointments), arrowEdge: .bottom)
            .tipBackground(Color.white)
            .padding(.horizontal)
            .padding(.top, 7.5)
    }

    // MARK: - Appointments View
    
    /// Main appointments view.  Contains the tip, list and collapsible.
    private var appointmentsView: some View {
        VStack {
            appointmentsList
            appointmentsCollapsible
            Spacer()
        }
    }

    /// List showing the appointments you have coming up.
    private var appointmentsList: some View {
        List {
            ForEach(appointments.orderedAppointments) { appointment in
                AppointmentCell(appointment: appointment)
                    .listRowSeparator(.hidden)
                    .onTapGesture {
                        viewModel.shouldShowAppointmentsForm = true
                        viewModel.selectedAppointment = appointment
                    }
            }
            .onDelete { indexSet in
                appointments.delete(context: .ordered, indexSet)
            }
            .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .listRowSpacing(-5)
    }

    /// Collapsible popup which shows the total cost of all appointments with some details about the cost.
    private var appointmentsCollapsible: some View {
        AppointmentsCollapsible(collapsedTotal: $viewModel.collapsedTotal)
            .padding(.vertical, viewModel.collapsedTotal ? 5 : 10)
    }

    // MARK: - Empty State View

    /// Empty state view that shows when you have no appointments.
    private var emptyStateView: some View {
        EmptyState(imageName: Constants.EmptyState.imageName,
                   title: Constants.EmptyState.title,
                   description: Constants.EmptyState.description)
    }
}

// MARK: - Constants

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

// MARK: - Previews

#Preview("Appointments View - With Appointments") {
    TabView {
        AppointmentsView()
            .tabItem {
                Label("Appointments", systemImage: "book")
            }
            .modifier(PreviewEnvironmentObjects())
    }
}

#Preview("Appointments View - Without Appointments") {
    let appointments = Appointments()
    appointments.appointments = []

    return TabView {
        AppointmentsView()
            .tabItem {
                Label("Appointments", systemImage: "book")
            }
            .environmentObject(appointments)
            .environmentObject(UserPreferences())
    }
}

