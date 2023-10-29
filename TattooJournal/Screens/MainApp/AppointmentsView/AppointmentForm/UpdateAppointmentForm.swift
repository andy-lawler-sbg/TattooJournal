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
                            buttonAction: {
            withAnimation {
                // MARK: - Shop
                if newShopToggle {
                    let newShop = Shop(name: shopName)
                    context.insert(newShop)
                    appointment.shop = newShop
                    newShop.appointments.append(appointment)
                } else {
                    if appointment.shop != shop {
                        appointment.shop = shop
                        shop.appointments.append(appointment)
                    }
                }

                // MARK: - Artist
                if newArtistToggle {
                    let newArtist = Artist(name: artistName, instagramHandle: artistInstagramHandle)
                    context.insert(newArtist)
                    appointment.artist = newArtist
                    newArtist.appointments.append(appointment)
                    shop.artist = newArtist
                } else {
                    if appointment.artist != artist {
                        appointment.artist = artist
                        artist.appointments.append(appointment)
                    }
                    if newShopToggle {
                        shop.artist = artist
                    }
                }

                // MARK: - Appointment
                appointment.shop = shop
                appointment.bodyPart = tattooLocation.rawValue

                if appointment.notifyMe {
                    notificationsHandler.deleteScheduledNotification(for: appointment)
                    notificationsHandler.scheduleNotifications(for: appointment)
                }
            }
        })
        .onAppear {
            tattooLocation = appointment.tattooLocation
            if let artist = appointment.artist {
                self.artist = artist
            }
            if let shop = appointment.shop {
                self.shop = shop
            }
        }
    }
}

#Preview {
    UpdateAppointmentForm(appointment: Appointment())
        .tint(AppThemeHandler().appColor)
        .modelContainer(for: [Appointment.self, Artist.self, Shop.self, UserPreferences.self])
}
