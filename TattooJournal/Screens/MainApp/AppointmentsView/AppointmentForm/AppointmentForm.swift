//
//  AppointmentForm.swift
//  TattooJournal
//
//  Created by Andrew Lawler on 22/10/2023.
//

import SwiftUI

struct AppointmentForm: View {

    @EnvironmentObject private var notificationsHandler: NotificationsHandler
    @Environment(\.modelContext) var context

    private let calendar = Calendar.current

    @State private var appointment = Appointment()
    @State private var date = Date()
    @State private var artistName: String = ""
    @State private var tattooLocation: TattooLocation = .head

    var body: some View {
        AppointmentFormView(type: .create,
                            date: $date,
                            name: $artistName,
                            price: $appointment.price,
                            design: $appointment.design,
                            notifyMe: $appointment.notifyMe,
                            tattooLocation: $tattooLocation,
                            buttonAction: {
            withAnimation {
                /// SwiftData
                context.insert(appointment)
                let artist = Artist(name: artistName, appointment: appointment)
                appointment.date = date
                appointment.artist = artist
                appointment.bodyPart = tattooLocation.rawValue
                context.insert(artist)
                
                if appointment.notifyMe {
                    notificationsHandler.scheduleNotifications(for: appointment)
                }
            }
        })
        .onAppear {
            var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            dateComponents.minute = (dateComponents.minute ?? 0) + 1
            dateComponents.second = 0
            date = calendar.date(from: dateComponents) ?? Date.now
        }
    }
}

#Preview {
    AppointmentForm()
        .tint(AppThemeHandler().appColor)
        .modelContainer(for: [Appointment.self, Artist.self, Shop.self, UserPreferences.self])
}
