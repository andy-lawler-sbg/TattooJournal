//
//  AppointmentForm.swift
//  TattooJournal
//
//  Created by Andrew Lawler on 22/10/2023.
//

import SwiftUI
import SwiftData

struct AppointmentForm: View {

    private let calendar = Calendar.current

    @EnvironmentObject private var notificationsHandler: NotificationsHandler
    @Environment(\.modelContext) var context
    @Query private var artists: [Artist]
    @Query private var shops: [Shop]

    @State private var appointment = Appointment()

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
        AppointmentFormView(type: .create,
                            date: $date,
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
                            buttonAction: { withAnimation { appointmentFormCreateAction() }}
        ).onAppear {
            configureDate()
            if let firstArtist = artists.first {
                artist = firstArtist
            }
            if let firstShop = shops.first {
                shop = firstShop
            }
        }
    }

    /// Setting the date to be at 0 mins and 0 seconds of the hour. This enables notifications to work better.
    private func configureDate() {
        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        dateComponents.minute = (dateComponents.minute ?? 0) + 1
        dateComponents.second = 0
        date = calendar.date(from: dateComponents) ?? Date.now
    }

    private func appointmentFormCreateAction() {
        context.insert(appointment)

        // MARK: - Appointment
        appointment.date = date
        appointment.bodyPart = tattooLocation.rawValue

        // MARK: - Shop
        if let shop {
            shop.appointments.append(appointment)
            appointment.shop = shop
        } else {
            let newShop = Shop(name: shopName)
            shop = newShop
            context.insert(newShop)
            newShop.appointments.append(appointment)
            appointment.shop = newShop
        }

        // MARK: - Artist
        if let artist {
            appointment.artist = artist
            artist.appointments.append(appointment)
            artist.shop = shop
            shop?.artists.append(artist)
        } else {
            let newArtist = Artist(name: artistName, instagramHandle: artistInstagramHandle)
            context.insert(newArtist)
            artist = newArtist
            appointment.artist = artist
            newArtist.shop = shop
            newArtist.appointments.append(appointment)
            shop?.artists.append(newArtist)
        }

        // MARK: - Notifications
        guard appointment.notifyMe else { return }
        notificationsHandler.scheduleNotifications(for: appointment)
    }
}

#Preview {
    AppointmentForm()
        .tint(AppThemeHandler().appColor)
        .modelContainer(for: [Appointment.self, Artist.self, Shop.self, UserPreferences.self])
}
