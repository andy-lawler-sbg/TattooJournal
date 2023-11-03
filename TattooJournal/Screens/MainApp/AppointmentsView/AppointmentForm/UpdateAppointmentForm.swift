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

    @State private var artist: Artist? = nil
    @State private var artistName: String = ""
    @State private var artistInstagramHandle: String = ""

    @State private var date = Date()
    @State private var tattooLocation: TattooLocation = .head

    @State private var shop: Shop? = nil
    @State private var shopName: String = ""
    @State private var selectedLocation: SearchResult? = nil

    var body: some View {
        AppointmentFormView(type: .update,
                            date: $appointment.date,
                            artist: $artist, 
                            artistName: $artistName,
                            artistInstagramHandle: $artistInstagramHandle,
                            price: $appointment.price,
                            design: $appointment.design,
                            tattooLocation: $tattooLocation, 
                            notifyMe: $appointment.notifyMe,
                            shop: $shop,
                            shopName: $shopName,
                            selectedLocation: $selectedLocation,
                            buttonAction: { appointmentFormUpdateAction() }
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
        if let shop {
            if let appointmentShop = appointment.shop {
                if shop != appointmentShop {
                    appointmentShop.appointments.removeAll(where: { $0 == appointment })
                }
            }
            appointment.shop = shop
            shop.appointments.append(appointment)
        } else {
            let newShop = Shop(name: shopName)
            newShop.appointments.append(appointment)
            context.insert(newShop)
            appointment.shop = newShop
        }

        // MARK: - Artist
        if let artist {
            if let appointmentArtist = appointment.artist {
                if artist != appointmentArtist {
                    appointmentArtist.appointments.removeAll(where: { $0 == appointment })
                }
            }
            appointment.artist = artist
            artist.appointments.append(appointment)
        } else {
            let newArtistInstagramHandle = artistInstagramHandle.isEmpty ? nil : artistInstagramHandle
            let newArtist = Artist(name: artistName, instagramHandle: newArtistInstagramHandle)
            context.insert(newArtist)
            appointment.artist = newArtist
            newArtist.appointments.append(appointment)
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
