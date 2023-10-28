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
