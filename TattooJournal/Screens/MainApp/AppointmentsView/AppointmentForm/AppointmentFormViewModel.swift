//
//  AppointmentFormViewModel.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI

final class AppointmentFormViewModel: ObservableObject {

    @Published var appointment = Appointment()
    @Published var isShowingMapView = false

    var editingAppointment = false
    var isValidForm: Bool { false }

    init(appointment: Appointment?) {
        if let appointment {
            self.appointment = appointment
            editingAppointment = true
        }
    }
}
