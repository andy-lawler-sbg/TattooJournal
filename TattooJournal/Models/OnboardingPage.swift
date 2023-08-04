//
//  OnboardingPage.swift
//  TattooJournal
//
//  Created by Andy Lawler on 04/08/2023.
//

import SwiftUI

struct OnboardingPage: Identifiable {
    let id: Int
    let title: String
    let image: String
    let description: String
    let showEnterPage: Bool
}

enum OnboardingData {
    static let pages: [OnboardingPage] = [
        .init(id: 1,
              title: "Log Appointments",
              image: "calendar.badge.clock",
              description: "Log your appointments and keep track of designs, spending, appointment times and much more.",
             showEnterPage: false),
        .init(id: 2,
              title: "Track Sessions",
              image: "clock.badge.questionmark",
              description: "Track each session you have. Manage how long it took and any memories you have.",
              showEnterPage: false),
        .init(id: 3,
              title: "View Statistics",
              image: "chart.line.uptrend.xyaxis",
              description: "Interested in statistics? View key information about your sessions, your art and much more.",
              showEnterPage: true)
    ]
}
