//
//  HistoryViewModel.swift
//  TattooJournal
//
//  Created by Andy Lawler on 28/04/2023.
//

import SwiftUI

@Observable
final class HistoryViewModel {
    var shouldShowVisitedShops = false
    var selectedAppointment: Appointment?
    var appointmentToShowDetailView: Appointment?
}

