//
//  AppointmentsViewModel.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI

final class AppointmentsViewModel: ObservableObject {
    @Published var shouldShowAppointmentsForm = false
    @Published var selectedAppointment: Appointment?
}
