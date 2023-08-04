//
//  PastTattoosViewModel.swift
//  TattooJournal
//
//  Created by Andy Lawler on 28/04/2023.
//

import SwiftUI

@Observable
final class PastTattoosViewModel {
    var shouldShowAppointmentsForm = false
    var selectedAppointment: Appointment?
    var shouldShowVisitedShops = false
}

