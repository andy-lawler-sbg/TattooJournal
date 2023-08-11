//
//  PastTattoosView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI
import TipKit

struct PastTattoosView: View {

    @EnvironmentObject var appointments: Appointments
    @Bindable var viewModel = PastTattoosViewModel()

    var pastTattoosTip = PastTattoosTip()

    var body: some View {
        NavigationStack {
            ZStack {
                if appointments.hasAppointments {
                    VStack {
                        TipView(pastTattoosTip, arrowEdge: .bottom)
                            .tipBackground(Color.white)
                            .padding(.horizontal)
                            .padding(.top, 7.5)
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
                    .onTapGesture(perform: Haptics.shared.successHaptic)
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
