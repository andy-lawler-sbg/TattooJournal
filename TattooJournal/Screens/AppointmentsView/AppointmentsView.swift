//
//  AppointmentsView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI

struct AppointmentsView: View {

    @EnvironmentObject var appointments: Appointments
    @EnvironmentObject var userPreferences: UserPreferences

    @StateObject var viewModel = AppointmentsViewModel()

    var shouldShowEmptyState: Bool { !appointments.hasAppointments }

    var costWithTip: Double {
        let multiplier = 1.0 + (Double(userPreferences.tipAmount.amount) / 100)
        return Double(appointments.cost) * multiplier
    }

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Text(Constants.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
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
                    }
                    .listStyle(.plain)
                    Text("Total: \(userPreferences.currencyString)\(costWithTip, specifier: "%.2f")")
                        .frame(height: 40)
                        .padding(.horizontal, 15)
                        .foregroundColor(.accentColor)
                        .background(Color.accentColor.opacity(0.2))
                        .cornerRadius(15)
                    Text("You will need the above amount to pay for all of your appointments. This price includes the %\(userPreferences.tipAmount.amount) tips.")
                        .multilineTextAlignment(.center)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .padding(.top, 5)
                    Spacer()
                }
                if shouldShowEmptyState {
                    EmptyState(imageName: Constants.EmptyState.title,
                               title: Constants.EmptyState.title,
                               description: Constants.EmptyState.description)
                }
            }
            .navigationTitle(Constants.title)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.shouldShowAppointmentsForm = true
                        viewModel.selectedAppointment = nil
                    } label: {
                        NavBarItem(imageName: Constants.ImageNames.add)
                    }
                }
            }
        }.sheet(isPresented: $viewModel.shouldShowAppointmentsForm) {
            AppointmentForm(isShowingAppointmentForm: $viewModel.shouldShowAppointmentsForm,
                            viewModel: AppointmentFormViewModel(appointment: viewModel.selectedAppointment))
        }
    }
}

private extension AppointmentsView {
    enum Constants {
        static let title = "🗂️ Appointments"
        static let description = "This list shows you your upcoming appointments. Swipe to delete any appointments you no longer have booked."

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

struct AppointmentsView_Previews: PreviewProvider {

    static var previews: some View {
        TabView {
            AppointmentsView()
                .tabItem {
                    Label("Appointments", systemImage: "book")
                }
                .modifier(PreviewEnvironmentObjects())
        }
    }
}
