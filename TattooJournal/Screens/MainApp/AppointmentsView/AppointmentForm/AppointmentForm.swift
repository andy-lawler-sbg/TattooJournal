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

    @State private var artist = Artist()
    @State private var artistName: String = ""
    @State private var artistInstagramHandle: String = ""
    @State private var newArtistToggle: Bool = false

    @State private var date = Date()
    @State private var tattooLocation: TattooLocation = .head

    @State private var shop = Shop()
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
                            buttonAction: {
            withAnimation {
                context.insert(appointment)

                // MARK: - Appointment
                appointment.date = date
                appointment.bodyPart = tattooLocation.rawValue

                // MARK: - Shop
                if newShopToggle || shops.isEmpty {
                    let newShop = Shop(name: shopName)
                    shop = newShop
                    context.insert(newShop)
                    appointment.shop = newShop
                    shop.appointments.append(appointment)
                } else {
                    appointment.shop = shop
                    shop.appointments.append(appointment)
                }

                // MARK: - Artist
                if newArtistToggle || artists.isEmpty {
                    let newArtist = Artist(name: artistName, instagramHandle: artistInstagramHandle)
                    artist = newArtist
                    context.insert(newArtist)
                    appointment.artist = newArtist
                    newArtist.appointments.append(appointment)
                    newArtist.shop = shop
                } else {
                    appointment.artist = artist
                    artist.appointments.append(appointment)
                    shop.artist = artist
                }

                // MARK: - Notifications
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
            if let firstArtist = artists.first {
                artist = firstArtist
            }
            if let firstShop = shops.first {
                shop = firstShop
            }
        }
    }
}

#Preview {
    AppointmentForm()
        .tint(AppThemeHandler().appColor)
        .modelContainer(for: [Appointment.self, Artist.self, Shop.self, UserPreferences.self])
}
