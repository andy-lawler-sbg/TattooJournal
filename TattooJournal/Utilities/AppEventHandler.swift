//
//  AppEventHandler.swift
//  TattooJournal
//
//  Created by Andy Lawler on 28/10/2023.
//

import Combine

/// AppEventHandler is an environment object which enables us to trigger app events.
/// This works via adding a subscriber within a viewModel on the page we want to trigger.
/// Once this is set up, we can simply just call `appEventHandler.eventPublisher.send(event)`
/// and then the subscriber should handle the call.
///
/// This is currently being used to deep link from the history page to the appointments page and then open the appointment form.
final class AppEventHandler: ObservableObject {
    let eventPublisher = PassthroughSubject<AppEvent, Never>()

    enum AppEvent {
        case addAppointment
    }
}
