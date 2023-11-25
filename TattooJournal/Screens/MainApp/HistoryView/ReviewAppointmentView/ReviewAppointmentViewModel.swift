//
//  ReviewAppointmentViewModel.swift
//  TattooJournal
//
//  Created by Andy Lawler on 28/10/2023.
//

import SwiftUI

@Observable
final class ReviewAppointmentViewModel {
    var appointment: Appointment

    init(appointment: Appointment) {
        self.appointment = appointment
    }
}
