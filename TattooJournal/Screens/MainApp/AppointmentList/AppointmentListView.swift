//
//  AppointmentListView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 25/11/2023.
//

import SwiftUI
import SwiftData

@Observable
final class AppointmentListViewModel {
    let appointments: [Appointment]
    var appointmentToEdit: Appointment?
    var appointmentToShowDetailView: Appointment?
    var appointmentToReview: Appointment?

    init(appointments: [Appointment], 
         appointmentToEdit: Appointment? = nil,
         appointmentToShowDetailView: Appointment? = nil
    ) {
        self.appointments = appointments
        self.appointmentToEdit = appointmentToEdit
        self.appointmentToShowDetailView = appointmentToShowDetailView
    }
}

struct AppointmentListView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var notificationsHandler: NotificationsHandler
    @Bindable var viewModel: AppointmentListViewModel

    func type(for appointment: Appointment) -> AppointmentCellViewModel.AppointmentCellType {
        if appointment.date > Date.now {
            return .upcoming
        } else {
            return .history
        }
    }

    @ViewBuilder
    func appointmentCell(for appointment: Appointment) -> some View {
        switch type(for: appointment) {
        case .history:
            AppointmentCell(viewModel: .init(appointment: appointment, cellType: .history, reviewAccessoryIconTap: {
                withAnimation {
                    viewModel.appointmentToReview = appointment
                }
            }, didTapAppointmentCell: {
                withAnimation {
                    viewModel.appointmentToShowDetailView = appointment
                }
            }))
            .swipeActions(allowsFullSwipe: false) {
                Button(role: .destructive) {
                    withAnimation {
                        context.delete(appointment)
                    }
                } label: {
                    Label("Delete", systemImage: "trash")
                        .symbolVariant(.fill)
                }
            }
        case .upcoming:
            AppointmentCell(viewModel: .init(appointment: appointment, cellType: .upcoming, didTapAppointmentCell: {
                withAnimation {
                    viewModel.appointmentToShowDetailView = appointment
                }
            }))
            .swipeActions(allowsFullSwipe: false) {
                Button(role: .destructive) {
                    withAnimation(.easeOut(duration: 10)) {
                        notificationsHandler.deleteScheduledNotification(for: appointment)
                        context.delete(appointment)
                    }
                } label: {
                    Label("Delete", systemImage: "trash")
                        .symbolVariant(.fill)
                }
                Button {
                    withAnimation(.linear) {
                        viewModel.appointmentToEdit = appointment
                    }
                } label: {
                    Label("Edit", systemImage: "pencil.and.list.clipboard")
                        .symbolVariant(.fill)
                }.tint(.yellow)
            }
        }
    }


    var body: some View {
        List {
            ForEach(viewModel.appointments) { appointment in
                appointmentCell(for: appointment)
                    .listRowSeparator(.hidden)
            }.listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .listRowSpacing(-5)
        .mask(LinearGradient(gradient: Gradient(stops: [
                    .init(color: .black, location: 0.75),
                    .init(color: .black, location: 0.85),
                    .init(color: .black, location: 0.95),
                    .init(color: .clear, location: 1)
                ]
        ), startPoint: .top, endPoint: .bottom))
        .sheet(item: $viewModel.appointmentToEdit) {
            withAnimation {
                viewModel.appointmentToEdit = nil
            }
        } content: { appointment in
            UpdateAppointmentForm(appointment: appointment)
        }
        .sheet(item: $viewModel.appointmentToShowDetailView) {
            withAnimation {
                viewModel.appointmentToShowDetailView = nil
            }
        } content: { appointment in
            AppointmentPopUpView(viewModel: .init(appointment: appointment, type: .appointments))
                .presentationDetents([.height(620), .large])
                .presentationDragIndicator(.visible)
        }
        .sheet(item: $viewModel.appointmentToReview, onDismiss: {
            viewModel.appointmentToReview = nil
        }, content: { appointment in
            ReviewAppointmentView(appointment: appointment)
                .presentationDetents([.medium, .large])
        })
    }
}
