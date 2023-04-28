//
//  HomeViewModel.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI

final class HomeViewModel: ObservableObject {
    @Published var shouldShowAppointmentForm = false
    @Published var shouldShowSettingsScreen = false
    @Published var shouldShowGetWhatYouGet = false
}
