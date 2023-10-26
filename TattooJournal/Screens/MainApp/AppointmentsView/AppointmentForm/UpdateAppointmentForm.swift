//
//  UpdateAppointmentForm.swift
//  TattooJournal
//
//  Created by Andrew Lawler on 22/10/2023.
//

import SwiftUI
import SwiftData

struct UpdateAppointmentForm: View {

    @Environment(\.modelContext) var context
    @Bindable var appointment: Appointment

    @State private var artistName: String = ""
    @State private var tattooLocation: TattooLocation = .head

    var body: some View {
        AppointmentFormView(type: .update,
                            date: $appointment.date,
                            name: $artistName,
                            price: $appointment.price,
                            design: $appointment.design,
                            notifyMe: $appointment.notifyMe,
                            tattooLocation: $tattooLocation,
                            buttonAction: {
            /// SwiftData
            let artist = Artist(name: artistName)
            if let currentArtist = appointment.artist {
                context.delete(currentArtist)
            }
            appointment.artist = artist
            appointment.bodyPart = tattooLocation.rawValue
            context.insert(artist)

            /// Notifications
            NotificationsTrigger.testNotifications(with: appointment)
        })
        .onAppear {
            tattooLocation = appointment.tattooLocation
            if let artist = appointment.artist {
                artistName = artist.name
            }
        }
    }
}

#Preview {
    UpdateAppointmentForm(appointment: Appointment())
        .tint(AppThemeHandler().appColor)
        .modelContainer(for: [Appointment.self, Artist.self, Shop.self, UserPreferences.self])
}
