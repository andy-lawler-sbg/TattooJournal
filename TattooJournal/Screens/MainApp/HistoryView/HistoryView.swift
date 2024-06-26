//
//  HistoryView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI
import SwiftData
import TipKit

struct HistoryView: View {

    @Binding var selectedPage: Int

    @EnvironmentObject private var appEventHandler: AppEventHandler
    @Environment(\.modelContext) private var context

    @Query(
        sort: \Appointment.date,
        order: .reverse
    ) private var queriedAppointments: [Appointment]

    private var appointments: [Appointment] {
        let startDate: Date = Date()
        return queriedAppointments.filter({ $0.date < startDate })
    }

    @Bindable private var viewModel = HistoryViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    tipView
                    if appointments.isEmpty {
                        emptyStateView
                    } else {
                        pastTattoosListView
                    }
                }
            }
            .background(Color(.background))
            .navigationTitle(Constants.title)
            .toolbar {
                if queriedAppointments.contains(where: { $0.shop?.locationLatitude != nil || $0.shop?.locationLongitude != nil }) {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            withAnimation {
                                viewModel.shouldShowVisitedShops = true
                            }
                        } label: {
                            NavBarItem(imageName: Constants.ImageNames.visitedShops)
                        }
                        .onTapGesture(perform: Haptics.shared.successHaptic)
                    }
                }
            }
            .sheet(isPresented: $viewModel.shouldShowVisitedShops) {
                VisitedShops()
            }
        }
    }

    // MARK: - Tip View

    /// Tip view which shows users how to use the page.
    private var tipView: some View {
        TipView(HistoryTip(), arrowEdge: .bottom)
            .tipBackground(Color(.cellBackground))
            .padding(.horizontal)
            .padding(.top, 7.5)
    }

    // MARK: - Past Tattoos List View

    /// Past Tattoos Live view.  Contains the tip and list
    private var pastTattoosListView: some View {
        VStack {
            AppointmentListView(viewModel: .init(appointments: appointments))
            AppointmentsCollapsible(viewModel: .init(appointments: appointments, type: .history))
            Spacer()
        }
    }

    // MARK: - Empty State View

    /// Empty state view that shows when you have no completed appointments
    private var emptyStateView: some View {
        EmptyState(imageName: Constants.EmptyState.imageName,
                   title: Constants.EmptyState.title,
                   description: Constants.EmptyState.description,
                   buttonText: Constants.EmptyState.buttonText,
                   action: {
            selectedPage = 2
            /// Our appointments view does not sink on the publisher until it shows for the first time. If a user doesn't open
            /// the appointments page first and hits this button, we need this delay to ensure we are currently waiting for this call.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                appEventHandler.eventPublisher.send(.addAppointment)
            }
        })

    }
}

// MARK: - Constants

private extension HistoryView {
    enum Constants {
        static let title = "History"

        enum ImageNames {
            static let visitedShops = "globe.desk"
        }

        enum EmptyState {
            static let imageName = "list.clipboard"
            static let title = "No Completed Apointments"
            static let description = "You currently have no completed appointments. You might want to add some."
            static let buttonText = "Add"
        }
    }
}

// MARK: - Previews

#Preview("Past Tattoos View") {
    TabView {
        HistoryView(selectedPage: .constant(1))
            .modelContainer(for: [Appointment.self, Artist.self, Shop.self, UserPreferences.self, TattooImage.self])
            .tabItem {
                Label("Past Tattoos", systemImage: "pencil.line")
            }
    }
}


