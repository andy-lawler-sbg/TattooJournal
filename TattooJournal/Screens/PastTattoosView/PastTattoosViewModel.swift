//
//  PastTattoosViewModel.swift
//  TattooJournal
//
//  Created by Andy Lawler on 28/04/2023.
//

import SwiftUI

final class PastTattoosViewModel: ObservableObject {
    @Published var shouldShowAppointmentsForm = false
    @Published var selectedAppointment: Appointment?
    @Published var shouldShowVisitedShops = false
}

