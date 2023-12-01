//
//  HomeViewModel.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI
import Combine

@Observable
final class HomeViewModel {
    private var appEventHandler: AppEventHandler?
    private var cancellables = Set<AnyCancellable>()

    var shouldShowSettingsScreen = false
    var shouldShowArtistForm = false

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
                case .goToSettings:
                    self.shouldShowSettingsScreen = true
                case .addAppointment:
                    print("➕ Adding appointments not supported on Home ➕")
                }
            }
            .store(in: &cancellables)
    }
}
