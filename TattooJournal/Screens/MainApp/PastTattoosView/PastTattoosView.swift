//
//  PastTattoosView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI

struct PastTattoosView: View {

    @EnvironmentObject var appointments: Appointments
    @Bindable var viewModel = PastTattoosViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                if appointments.hasAppointments {
                    VStack {
                        InformationPopUp(text: Constants.description)
                            .padding(.top, 10)
                        List {
                            ForEach(appointments.completedAppointments) { appointment in
                                AppointmentCell(appointment: appointment)
                                    .listRowSeparator(.hidden)
                                    .onTapGesture {
                                        viewModel.shouldShowAppointmentsForm = true
                                        viewModel.selectedAppointment = appointment
                                    }
                            }.onDelete { indexSet in
                                appointments.delete(context: .completed, indexSet)
                            }
                            .listRowBackground(Color.clear)
                        }
                        .listStyle(.plain)
                        .scrollIndicators(.hidden)

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
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.shouldShowVisitedShops = true
                    } label: {
                        NavBarItem(imageName: Constants.ImageNames.visitedShops)
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.shouldShowAppointmentsForm) {
            AppointmentForm(isShowingAppointmentForm: $viewModel.shouldShowAppointmentsForm,
                            viewModel: AppointmentFormViewModel(appointment: viewModel.selectedAppointment))
        }
        .sheet(isPresented: $viewModel.shouldShowVisitedShops) {
            VisitedShops(shouldShowVisitedShops: $viewModel.shouldShowVisitedShops)
        }
    }
}

private extension PastTattoosView {
    enum Constants {
        static let title = "🕰️ Past Tattoos"
        static let description = "This list shows you the tattoo's you have completed. If you did in-fact miss an appointment feel free to swipe to delete it."

        enum ImageNames {
            static let visitedShops = "globe.desk"
        }

        enum EmptyState {
            static let imageName = "bookmark.slash"
            static let title = "No Completed Appointments"
            static let description = "You should get some tattoos."
        }
    }
}

#Preview {
    TabView {
        PastTattoosView()
            .tabItem {
                Label("Past Tattoos", systemImage: "pencil.line")
            }
            .modifier(PreviewEnvironmentObjects())
    }
}
