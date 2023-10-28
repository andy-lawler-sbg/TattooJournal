//
//  TJTabView+Extensions.swift
//  TattooJournal
//
//  Created by Andy Lawler on 28/10/2023.
//

import Foundation

// MARK: - User Preferences Setup
extension TJTabView {
    func setupUserPreferences() async {
        guard queriedUserPreferences.count < 1 else { return }
        let userPreferences = UserPreferences(currencyString: CurrencyType.sterling.rawValue,
                                              tipAmountString: TipAmountType.tenPercent.rawValue)
        context.insert(userPreferences)
        try? context.save()
    }
}

// MARK: - Review Screen Functionality
extension TJTabView {
    var lastClosedApp: Date? {
        UserDefaults.standard.object(forKey: Constants.lastClosedAppKey) as? Date
    }

    var filtered: [Appointment]? {
        guard let lastClosedApp else { return nil }
        let startDate = Date.now
        /// We might want to change this so that it doesn't actually run for a few hours. Currently it's Date -> now but the user could open the app mid appointment.
        /// If we keep this logic the same, there needs to be another way to review sessions, not just via this popup logic.
        let appointments = queriedAppointments.filter({ $0.date < startDate && $0.date > lastClosedApp })
        return appointments.isEmpty ? nil : appointments
    }

    func appDidEnterBackground() {
        UserDefaults.standard.set(Date.now, forKey: Constants.lastClosedAppKey)
        shouldShowAppointmentReviewPage = false
    }

    func appDidEnterForeground() {
        guard filtered != nil else { return }
        shouldShowAppointmentReviewPage = true
    }
}

extension TJTabView {
    enum Constants {
        static let lastClosedAppKey = "lastClosedApp"
    }
}
