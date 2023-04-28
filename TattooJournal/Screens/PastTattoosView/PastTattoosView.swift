//
//  PastTattoosView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI

struct PastTattoosView: View {

    @EnvironmentObject var appointments: Appointments

    @StateObject var viewModel = PastTattoosViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                Text(Constants.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
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
                }
                .listStyle(.plain)
            }
            .navigationTitle(Constants.title)
            .toolbar {
                Button {
                    viewModel.shouldShowVisitedShops = true
                } label: {
                    NavBarItem(imageName: Constants.ImageNames.visitedShops)
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
    }
}

struct PastTattoosView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            PastTattoosView()
                .tabItem {
                    Label("Past Tattoos", systemImage: "pencil.line")
                }
                .modifier(PreviewEnvironmentObjects())
        }
    }
}
