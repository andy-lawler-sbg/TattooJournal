//
//  AppointmentsView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI
import SwiftData
import TipKit

/// Appointments View to show the scheduled appointments a User has.
struct AppointmentsView: View {
    
    @EnvironmentObject private var appEventHandler: AppEventHandler
    @EnvironmentObject private var notificationsHandler: NotificationsHandler
    @Environment(\.modelContext) var context

    @Query(
        sort: \Appointment.date,
        order: .forward
    ) private var queriedAppointments: [Appointment]

    @Query private var artists: [Artist]

    private var appointments: [Appointment] {
        let startDate: Date = Date()
        return queriedAppointments.filter({ $0.date >= startDate })
    }

    @Bindable var viewModel = AppointmentsViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    tipView
                    if appointments.isEmpty {
                        emptyStateView
                    } else {
                        appointmentsView
                    }
                }
            }
            .background(Color(.background))
            .navigationTitle(Constants.title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation {
                            viewModel.shouldShowAppointmentsForm = true
                        }
                    } label: {
                        NavBarItem(imageName: Constants.ImageNames.add)
                    }
                    .onTapGesture(perform: Haptics.shared.successHaptic)
                }
            }
            .sheet(isPresented: $viewModel.shouldShowAppointmentsForm) {
                AppointmentForm()
            }
            .sheet(item: $viewModel.selectedAppointment) {
                withAnimation {
                    viewModel.selectedAppointment = nil
                }
            } content: { appointment in
                UpdateAppointmentForm(appointment: appointment)
            }
            .onAppear {
                viewModel.setup(appEventHandler: appEventHandler)
            }
        }
    }

    // MARK: - Tip View

    /// Tip view which shows users how to use the page.
    private var tipView: some View {
        TipView(AppointmentsTip(hasAppointments: !appointments.isEmpty), arrowEdge: .bottom)
            .tipBackground(Color(.cellBackground))
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
            ForEach(appointments) { appointment in
                AppointmentCell(viewModel: .init(appointment: appointment, cellType: .upcoming))
                    .listRowSeparator(.hidden)
                    .swipeActions(allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            withAnimation(.easeOut(duration: 10)) {
                                notificationsHandler.deleteScheduledNotification(for: appointment)
                                if let currentArtist = appointment.artist {
                                    context.delete(currentArtist)
                                }
                                context.delete(appointment)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                                .symbolVariant(.fill)
                        }

                        Button {
                            withAnimation(.linear) {
                                viewModel.selectedAppointment = appointment
                            }
                        } label: {
                            Label("Edit", systemImage: "pencil.and.list.clipboard")
                                .symbolVariant(.fill)
                        }
                        .tint(.yellow)
                    }
            }.listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .listRowSpacing(-5)
    }

    /// Collapsible popup which shows the total cost of all appointments with some details about the cost.
    private var appointmentsCollapsible: some View {
        AppointmentsCollapsible(viewModel: .init(appointments: appointments))
    }

    // MARK: - Empty State View

    /// Empty state view that shows when you have no appointments.
    private var emptyStateView: some View {
        EmptyState(imageName: Constants.EmptyState.imageName,
                   title: Constants.EmptyState.title,
                   description: Constants.EmptyState.description,
                   buttonText: Constants.EmptyState.buttonText,
                   action: { appEventHandler.eventPublisher.send(.addAppointment) })
    }
}

// MARK: - Constants

private extension AppointmentsView {
    enum Constants {
        static let title = "Appointments"

        enum ImageNames {
            static let add = "plus"
        }

        enum EmptyState {
            static let imageName = "bookmark.slash"
            static let title = "No Appointments"
            static let description = "You currently have no upcoming appointments. Maybe treat yourself and add one in?"
            static let buttonText = "Add"
        }
    }
}

// MARK: - Previews

#Preview("Appointments View") {
    TabView {
        AppointmentsView()
            .tabItem {
                Label("Appointments", systemImage: "list.clipboard.fill")
            }
            .modelContainer(for: [Appointment.self, Artist.self, Shop.self, UserPreferences.self])
    }            
    .task {
        try? Tips.configure([.displayFrequency(.immediate), .datastoreLocation(.applicationDefault)])
    }
}

