//
//  Appointments.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI

@Observable
final class Appointments: ObservableObject {

    var appointments: [Appointment] = [MockAppointmentData().appointment,
                                                  MockAppointmentData().appointment2,
                                                  MockAppointmentData().appointment3,
                                                  MockAppointmentData().appointment4,
                                                  MockAppointmentData().appointment5,
                                                  MockAppointmentData().appointment6,
    ]

    // MARK: - Computed Properties

    var hasAppointments: Bool { !appointments.isEmpty }

    var hasShops: Bool { hasAppointments }

    var cost: Double {
        guard hasAppointments else { return 0 }
        let prices = appointments.compactMap { Double($0.price) }
        return prices.reduce(0, +)
    }

    var orderedAppointments: [Appointment] {
        sortAppointments(removeAppointmentsTo(show: .future))
    }

    var completedAppointments: [Appointment] {
        sortAppointments(removeAppointmentsTo(show: .past))
    }

    // MARK: - Add & Delete

    func add(_ appointment: Appointment) {
        appointments.append(appointment)
    }

    func delete(_ appointment: Appointment) {
        guard let index = appointments.firstIndex(where: { $0.id == appointment.id }) else { return }
        appointments.remove(at: index)
    }

    enum DeleteContext {
        case completed
        case ordered
    }

    func delete(context: DeleteContext, _ indexSet: IndexSet) {
        switch context {
        case .completed:
            deleteForContext(appointmentsOrder: completedAppointments, indexSet)
        case .ordered:
            deleteForContext(appointmentsOrder: orderedAppointments, indexSet)
        }
    }

    private func deleteForContext(appointmentsOrder: [Appointment], _ indexSet: IndexSet) {
        let orderShownToUser = appointmentsOrder
        for index in indexSet {
            let item = orderShownToUser[index]
            delete(item)
        }
    }

    enum FilterType {
        case future
        case past
    }

    private func removeAppointmentsTo(show filter: FilterType) -> [Appointment]  {
        switch filter {
        case .future:
            return appointments.filter { $0.date > Date.now }
        case .past:
            return appointments.filter { $0.date < Date.now }
        }
    }

    // MARK: - Edit

    func edit(_ appointment: Appointment) {
        guard let index = appointments.firstIndex(where: { $0.id == appointment.id }) else { return }
        appointments[index] = appointment
    }

    // MARK: - Helper Functions

    func sortAppointments(_ appointments: [Appointment]) -> [Appointment] {
        appointments.sorted { $0.date < $1.date }
    }

    func nextAppointment() -> Appointment? {
        guard let appointment = sortAppointments(removeAppointmentsTo(show: .future)).first else { return nil }

        var date = appointment.date
        var selectedAppointment = appointment

        let _ = appointments.map { appointment in
            if appointment.date < date {
                date = appointment.date
                selectedAppointment = appointment
            }
        }
        return selectedAppointment
    }

    var shops: [Shop]? {
        hasAppointments ? appointments.compactMap { $0.shop } : nil
    }
}
