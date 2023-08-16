//
//  AppointmentsViewModel.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI

@Observable
final class AppointmentsViewModel {

    var shouldShowAppointmentsForm = false
    var collapsedTotal = false
    var selectedAppointment: Appointment?

}
