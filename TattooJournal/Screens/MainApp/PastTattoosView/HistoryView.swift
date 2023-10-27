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

    @Environment(\.modelContext) private var context

    @Query(
        
        sort: \Appointment.date,
        order: .forward
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
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.shouldShowVisitedShops = true
                    } label: {
                        NavBarItem(imageName: Constants.ImageNames.visitedShops)
                    }
                    .onTapGesture(perform: Haptics.shared.successHaptic)
                }
            }
            .sheet(isPresented: $viewModel.shouldShowVisitedShops) {
                VisitedShops(shouldShowVisitedShops: $viewModel.shouldShowVisitedShops)
            }
            .sheet(item: $viewModel.selectedAppointment) {
                viewModel.selectedAppointment = nil
            } content: { appointment in
                UpdateAppointmentForm(appointment: appointment)
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
            pastTattoosList
            Spacer()
        }
    }

    /// List showing the appointments you have completed
    private var pastTattoosList: some View {
        List {
            ForEach(appointments) { appointment in
                AppointmentCell(viewModel: .init(appointment: appointment))
                    .onTapGesture {}
                    .listRowSeparator(.hidden)
                    .swipeActions {
                        Button(role: .destructive) {
                            withAnimation {
                                if let currentArtist = appointment.artist {
                                    context.delete(currentArtist)
                                }
                                context.delete(appointment)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                                .symbolVariant(.fill)
                        }
                    }
            }
            .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .listRowSpacing(-5)
    }

    // MARK: - Empty State View

    /// Empty state view that shows when you have no completed appointments
    private var emptyStateView: some View {
        VStack {
            EmptyState(imageName: Constants.EmptyState.imageName,
                       title: Constants.EmptyState.title,
                       description: Constants.EmptyState.description,
                       buttonText: Constants.EmptyState.buttonText,
                       action: { selectedPage = 2 })
            Spacer()
        }
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
            static let description = "You currently have no completed appointments. You might want to add some on the appointments page."
            static let buttonText = "Add"
        }
    }
}

// MARK: - Previews

#Preview("Past Tattoos View") {
    TabView {
        HistoryView(selectedPage: .constant(1))
            .modelContainer(for: [Appointment.self, Artist.self, Shop.self, UserPreferences.self])
            .tabItem {
                Label("Past Tattoos", systemImage: "pencil.line")
            }
    }
}


