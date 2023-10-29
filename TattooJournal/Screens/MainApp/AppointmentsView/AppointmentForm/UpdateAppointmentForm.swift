//
//  UpdateAppointmentForm.swift
//  TattooJournal
//
//  Created by Andrew Lawler on 22/10/2023.
//

import SwiftUI
import SwiftData

struct UpdateAppointmentForm: View {

    @EnvironmentObject private var notificationsHandler: NotificationsHandler
    @Environment(\.modelContext) var context
    @Bindable var appointment: Appointment

    @State private var artist: Artist? = Artist()
    @State private var artistName: String = ""
    @State private var artistInstagramHandle: String = ""
    @State private var newArtistToggle: Bool = false

    @State private var date = Date()
    @State private var tattooLocation: TattooLocation = .head

    @State private var shop: Shop? = Shop()
    @State private var shopName: String = ""
    @State private var newShopToggle: Bool = false

    var body: some View {
        AppointmentFormView(type: .update,
                            date: $appointment.date,
                            artist: $artist, 
                            artistName: $artistName,
                            artistInstagramHandle: $artistInstagramHandle,
                            newArtistToggle: $newArtistToggle,
                            price: $appointment.price,
                            design: $appointment.design,
                            tattooLocation: $tattooLocation, 
                            notifyMe: $appointment.notifyMe,
                            shop: $shop,
                            shopName: $shopName,
                            newShopToggle: $newShopToggle,
                            buttonAction: { withAnimation { appointmentFormUpdateAction() } }
        ).onAppear {
            tattooLocation = appointment.tattooLocation
            if let artist = appointment.artist {
                self.artist = artist
            }
            if let shop = appointment.shop {
                self.shop = shop
            }
        }
    }

    private func appointmentFormUpdateAction() {
        // MARK: - Shop
        var addedNewShop = false

        if let shop {
            /// Remove appointment from past shops appointments
            guard let appointmentShop = appointment.shop, appointmentShop != shop else { return }
            appointmentShop.appointments.removeAll(where: { $0 == appointment })
            appointment.shop = shop
            shop.appointments.append(appointment)
        } else {
            let newShop = Shop(name: shopName)
            shop = newShop
            addedNewShop = true
            context.insert(newShop)
            appointment.shop = newShop
            newShop.appointments.append(appointment)
        }

        // MARK: - Artist
        if let artist {
            guard let appointmentArtist = appointment.artist, appointmentArtist != artist else { return }
            appointmentArtist.appointments.removeAll(where: { $0 == appointment })
            appointment.artist = artist
            artist.appointments.append(appointment)

            /// If its a new shop but current artist, add it in
            if addedNewShop {
                shop?.artists.append(artist)
            }

        } else {
            let newArtist = Artist(name: artistName, instagramHandle: artistInstagramHandle)
            context.insert(newArtist)
            artist = newArtist

            appointment.artist = newArtist

            newArtist.appointments.append(appointment)
            newArtist.shop = shop

            shop?.artists.append(newArtist)
        }

        // MARK: - Appointment
        appointment.bodyPart = tattooLocation.rawValue

        if appointment.notifyMe {
            notificationsHandler.deleteScheduledNotification(for: appointment)
            notificationsHandler.scheduleNotifications(for: appointment)
        }
    }
}

#Preview {
    UpdateAppointmentForm(appointment: Appointment())
        .tint(AppThemeHandler().appColor)
        .modelContainer(for: [Appointment.self, Artist.self, Shop.self, UserPreferences.self])
}
