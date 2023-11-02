//
//  AppointmentsViewModel.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI
import Combine

@Observable
final class AppointmentsViewModel {
    private var appEventHandler: AppEventHandler?
    private var cancellables = Set<AnyCancellable>()

    var shouldShowAppointmentsForm = false
    var shouldShowArtistAndShopList = false
    
    var appointmentToEdit: Appointment?
    var appointmentToShowDetailView: Appointment?

    func setup(appEventHandler: AppEventHandler) {
        self.appEventHandler = appEventHandler
        subscribe()
    }

    func subscribe() {
        guard let appEventHandler else { return }
        appEventHandler.eventPublisher
            .receive(on: DispatchQueue.main)
            .sink { [self] appEvent in
                switch appEvent {
                case .addAppointment:
                    shouldShowAppointmentsForm = true
                case .goToSettings:
                    print("➕ Going to settings not supported on Appointments ➕")
                }
            }
            .store(in: &cancellables)
    }
}
