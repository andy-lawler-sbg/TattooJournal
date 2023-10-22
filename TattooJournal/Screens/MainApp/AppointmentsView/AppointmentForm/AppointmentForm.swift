//
//  AppointmentForm.swift
//  TattooJournal
//
//  Created by Andrew Lawler on 22/10/2023.
//

import SwiftUI

struct AppointmentForm: View {

    @Environment(\.modelContext) var context
    @State private var appointment = Appointment()
    @State private var artistName: String = ""

    var body: some View {
        AppointmentFormView(type: .create,
                            date: $appointment.date,
                            name: $artistName,
                            price: $appointment.price,
                            design: $appointment.design,
                            notifyMe: $appointment.notifyMe, buttonAction: {
            /// SwiftData
            context.insert(appointment)
            let artist = Artist(name: artistName, appointment: appointment)
            appointment.artist = artist
            context.insert(artist)

            /// Notifications
            NotificationsTrigger.testNotifications(with: appointment)
        })
    }
}

#Preview {
    AppointmentForm()
        .tint(UserPreferences().appColor)
        .modelContainer(for: [Appointment.self, Artist.self, Shop.self])
}
