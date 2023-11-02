//
//  AppointmentPopUpView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 02/11/2023.
//

import SwiftUI
import SwiftData
import TipKit

enum AppointmentPopUpType {
    case appointments, history
}

@Observable
final class AppointmentPopUpViewModel {
    
    var appointment: Appointment
    var type: AppointmentPopUpType

    init(appointment: Appointment, type: AppointmentPopUpType = .appointments) {
        self.appointment = appointment
        self.type = type
    }
}

struct AppointmentPopUpView: View {

    @Query private var queriedUserPreferences: [UserPreferences]
    private var userPreferences: UserPreferences {
        queriedUserPreferences.first!
    }

    @Environment(\.dismiss) private var dismiss
    var viewModel: AppointmentPopUpViewModel

    private var dateString: String {
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .full
        formatter1.timeStyle = .short
        return formatter1.string(from: viewModel.appointment.date)
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Appointment Information") {
                    SettingsItemView(itemView: Text(dateString), imageName: "calendar", backgroundColor: .red)
                    if let artist = viewModel.appointment.artist {
                        SettingsItemView(itemView: Text(artist.name), imageName: "person.fill", backgroundColor: .mint)
                    }
                    SettingsItemView(itemView: Text(viewModel.appointment.price), imageName: "\(userPreferences.currency.rawValue)sign", backgroundColor: .blue)
                    SettingsItemView(itemView: Text(viewModel.appointment.design), imageName: "paintbrush.pointed.fill", backgroundColor: .green)
                    if let shop = viewModel.appointment.shop {
                        SettingsItemView(itemView: Text(shop.name), imageName: "house.fill", backgroundColor: .purple)
                    }
                    SettingsItemView(itemView: Text(viewModel.appointment.notifyMeDescription), imageName: viewModel.appointment.notifyMe ? "bell.fill" : "bell", backgroundColor: .orange)
                    SettingsItemView(itemView: Text(viewModel.appointment.bodyPart), imageName: "figure.mind.and.body", backgroundColor: .pink)
                }
            }
            .navigationTitle("Appointment Details")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.background))
            .popoverTip(AppointmentDetailViewTip(type: viewModel.type))
            .tipBackground(Color(.cellBackground))
        }
        .overlay(
            Button {
                dismiss()
            } label: {
                XMarkButton()
            }, alignment: .topTrailing
        )
    }
}

#Preview {
    AppointmentPopUpView(viewModel: .init(appointment: MockAppointments.mockAppointment))
}

enum MockAppointments {
    static let mockAppointment = Appointment(date: .now, price: "250", design: "American Eagle", notifyMe: false, bodyPart: TattooLocation.arms.rawValue)
}
