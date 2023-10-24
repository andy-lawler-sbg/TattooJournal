//
//  AppointmentSpendingChartViewModel.swift
//  TattooJournal
//
//  Created by Andy Lawler on 24/10/2023.
//

import SwiftUI

@Observable
final class AppointmentSpendingChartViewModel {
    var appointments: [Appointment]

    init(appointments: [Appointment]) {
        self.appointments = appointments
    }
}
