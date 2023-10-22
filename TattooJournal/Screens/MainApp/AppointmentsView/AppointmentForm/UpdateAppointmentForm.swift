//
//  UpdateAppointmentForm.swift
//  TattooJournal
//
//  Created by Andy Lawler on 20/10/2023.
//

import SwiftUI
import SwiftData

struct UpdateAppointmentForm: View {

    @EnvironmentObject var userPreferences: UserPreferences
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context

    @Bindable var appointment: Appointment

    @State private var artistName: String = ""

    @FocusState private var focusedTextField: FormTextField?
    enum FormTextField {
        case artist, date, price, design
    }

    var body: some View {
        NavigationStack {
            Form {
                keyDetailsSection
                notificationSection
                actionButtonSections
            }
            .navigationTitle("Log Appointment")
            .background(Color(.background))
        }
        .overlay(
            Button {
                dismiss()
            } label: {
                XMarkButton()
            }, alignment: .topTrailing
        )
        .onAppear {
            if let artist = appointment.artist {
                artistName = artist.name
            }
        }
    }

    private var keyDetailsSection: some View {
        Section {
            DatePicker("Date", selection: $appointment.date)
            TextField("Artist", text: $artistName)
                .focused($focusedTextField, equals: .artist)
                .onSubmit { focusedTextField = .price }
                .submitLabel(.next)
            TextField("Price", text: $appointment.price)
                .keyboardType(.numbersAndPunctuation)
                .focused($focusedTextField, equals: .price)
                .onSubmit { focusedTextField = .design }
                .submitLabel(.next)
            TextField("Design", text: $appointment.design)
                .focused($focusedTextField, equals: .design)
                .onSubmit { focusedTextField = nil }
                .submitLabel(.continue)
        } header: {
            Text("Key Details")
        } footer: {
            Text("This includes your date, artist, price and design.")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }

    private var notificationSection: some View {
        Section {
            Toggle("Notify Me", isOn: $appointment.notifyMe)
                .tint(userPreferences.appColor)
        } header: {
            Text("Notifications")
        } footer: {
            Text("Turn this on to receive reminder notifications before your appointment.")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }

    private var actionButtonSections: some View {
        Section {
            Button("Update") {
                withAnimation {

                    /// SwiftData
                    let artist = Artist(name: artistName)
                    if let currentArtist = appointment.artist {
                        context.delete(currentArtist)
                    }
                    appointment.artist = artist
                    context.insert(artist)

                    /// Notifications
                    NotificationsTrigger.testNotifications(with: appointment)
                }
                dismiss()
            }
        }
    }
}

struct NotificationsTrigger {
    static func testNotifications(with appointment: Appointment) {
        if appointment.notifyMe {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    NotificationsTrigger.triggerNotification(for: appointment)
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }

    static func triggerNotification(for appointment: Appointment) {
        if let artistName = appointment.artist?.name {
            let content = UNMutableNotificationContent()
            content.title = artistName
            content.subtitle = String(describing: appointment.date.formatted())
            content.sound = UNNotificationSound.default

            // show this notification five seconds from now
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request)
        }
    }
}
