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

    var userPreferences: UserPreferences?
    var appointment: Appointment
    var type: AppointmentPopUpType

    var dateString: String {
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .full
        formatter1.timeStyle = .short
        return formatter1.string(from: appointment.date)
    }

    var pageTitle: String {
        "Appointment Details"
    }

    var pageContent: [SettingsItemView<Text>] {
        var items: [SettingsItemView<Text>] = []
        
        items.append(SettingsItemView(itemView: Text(dateString), imageName: "calendar", backgroundColor: .red))
        if let artist = appointment.artist {
            items.append(SettingsItemView(itemView: Text(artist.name), imageName: "person.fill", backgroundColor: .mint))
        }
        if let userPreferences {
            items.append(SettingsItemView(itemView: Text(appointment.price), imageName: "\(userPreferences.currency.rawValue)sign", backgroundColor: .blue))
        }
        items.append(SettingsItemView(itemView: Text(appointment.design), imageName: "paintbrush.pointed.fill", backgroundColor: .green))
        if let shop = appointment.shop {
            items.append(SettingsItemView(itemView: Text(shop.name), imageName: "house.fill", backgroundColor: .purple))
        }
        items.append(SettingsItemView(itemView: Text(appointment.bodyPart), imageName: "figure.mind.and.body", backgroundColor: .pink))

        switch type {
        case .appointments:
            items.append(SettingsItemView(itemView: Text(appointment.notifyMeDescription), imageName: appointment.notifyMe ? "bell.fill" : "bell", backgroundColor: .orange))
        case .history:
            items.append(SettingsItemView(itemView: Text(appointment.reviewDescription), imageName: appointment.review != nil ? "star.fill" : "star", backgroundColor: .orange))
        }
        return items
    }

    init(appointment: Appointment, type: AppointmentPopUpType = .appointments) {
        self.appointment = appointment
        self.type = type
    }
}

struct AppointmentPopUpView: View {
    
    @EnvironmentObject private var themeHandler: AppThemeHandler
    @Environment(\.dismiss) private var dismiss
    @Query private var queriedUserPreferences: [UserPreferences]
    private var userPreferences: UserPreferences {
        queriedUserPreferences.first!
    }

    var viewModel: AppointmentPopUpViewModel

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(viewModel.pageContent, id: \.id) { page in
                        page
                    }
                } footer: {
                    Text("Change any of the information above by swiping to edit on the appointment screen or use the button above.")
                        .bold()
                        .multilineTextAlignment(.center)
                        .font(.caption)
                        .foregroundColor(themeHandler.appColor)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(themeHandler.appColor.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: .black.opacity(0.05), radius: 5, y: 3)
                        .padding(.top)
                }
            }
            .scrollIndicators(.hidden)
            .navigationTitle(viewModel.pageTitle)
            .navigationBarTitleDisplayMode(.large)
            .background(Color(.background))
            .popoverTip(AppointmentDetailViewTip(type: viewModel.type))
            .tipBackground(Color(.cellBackground))
        }
        .onAppear {
            viewModel.userPreferences = userPreferences
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
