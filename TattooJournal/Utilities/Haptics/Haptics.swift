//
//  Haptics.swift
//  TattooJournal
//
//  Created by Andy Lawler on 06/08/2023.
//

import UIKit

final class Haptics {

    static let shared = Haptics()
    private init() {}

    func successHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    func errorHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }

    func warningHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
}
