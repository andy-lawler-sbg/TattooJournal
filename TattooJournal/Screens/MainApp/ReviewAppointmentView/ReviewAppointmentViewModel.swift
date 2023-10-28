//
//  ReviewAppointmentViewModel.swift
//  TattooJournal
//
//  Created by Andy Lawler on 28/10/2023.
//

import SwiftUI

@Observable
final class ReviewAppointmentViewModel {
    var appointments: [Appointment]

    init(appointments: [Appointment]) {
        self.appointments = appointments
    }
}
