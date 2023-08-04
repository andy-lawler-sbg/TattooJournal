//
//  AppointmentFormViewModel.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI

@Observable
final class AppointmentFormViewModel {

    var appointment = Appointment()
    var isShowingMapView = false

    var editingAppointment = false
    var isValidForm: Bool { false }

    init(appointment: Appointment?) {
        if let appointment {
            self.appointment = appointment
            editingAppointment = true
        }
    }
}
