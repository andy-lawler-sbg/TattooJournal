//
//  AppointmentForm.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI

struct AppointmentForm: View {
    
    @EnvironmentObject var userPreferences: UserPreferences

    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context

    @State private var appointment = Appointment()

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
            Button("Create") {
                withAnimation {
                    /// SwiftData
                    context.insert(appointment)
                    let artist = Artist(name: artistName, appointment: appointment)
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

#Preview {
    AppointmentForm()
        .tint(UserPreferences().appColor)
        .environmentObject(UserPreferences())
        .modelContainer(for: [Appointment.self, Artist.self, Shop.self])
}
