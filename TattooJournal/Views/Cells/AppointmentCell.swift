//
//  AppointmentCell.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI
import SwiftData

@Observable
class AppointmentCellViewModel {
    var appointment: Appointment
    var shouldShowNotificationsButton: Bool

    init(appointment: Appointment, shouldShowNotificationsButton: Bool = true) {
        self.appointment = appointment
        self.shouldShowNotificationsButton = shouldShowNotificationsButton
    }
}

struct AppointmentCell: View {

    @EnvironmentObject var themeHandler: AppThemeHandler
    @EnvironmentObject var notificationsHandler: NotificationsHandler
    @Query private var queriedUserPreferences: [UserPreferences]
    var userPreferences: UserPreferences {
        queriedUserPreferences.first!
    }
    var viewModel: AppointmentCellViewModel

    var dateString: String {
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .full
        formatter1.timeStyle = .short
        return formatter1.string(from: viewModel.appointment.date)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 15) {
                if let artistName = viewModel.appointment.artist?.name {
                    Text(artistName)
                        .foregroundStyle(themeHandler.appColor)
                        .font(.headline)
                        .fontWeight(.bold)
                }
                HStack(spacing: 10) {
                    if viewModel.appointment.price != "" {
                        Text("\(userPreferences.currency.displayValue)\(viewModel.appointment.price)")
                            .font(.caption).bold()
                            .foregroundStyle(Color.secondary)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 8)
                            .background(Color(.buttonCapsule))
                            .clipShape(.capsule)
                    }
                    Text(viewModel.appointment.bodyPart)
                        .font(.caption).bold()
                        .foregroundStyle(Color.white)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 8)
                        .background(themeHandler.appColor.opacity(0.75))
                        .clipShape(.capsule)
                }
                Spacer()
            }
            if let shopName = viewModel.appointment.shop?.name {
                Text(shopName)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            Text(dateString)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
        .overlay(alignment: .bottomTrailing) {
            if viewModel.shouldShowNotificationsButton {
                Image(systemName: viewModel.appointment.notifyMe ? "bell.fill" : "bell")
                    .resizable()
                    .frame(width: 13, height: 13)
                    .foregroundStyle(viewModel.appointment.notifyMe ? themeHandler.appColor : Color.gray)
                    .padding(6)
                    .background(Color(.buttonCapsule))
                    .clipShape(.circle)
                    .frame(width: 80, height: 80, alignment: .bottomTrailing)
                    .background(Color(.cellBackground))
                    .padding(10)
                    .onTapGesture {
                        viewModel.appointment.notifyMe.toggle()
                        if viewModel.appointment.notifyMe {
                            notificationsHandler.scheduleNotifications(for: viewModel.appointment)
                        } else {
                            notificationsHandler.deleteScheduledNotification(for: viewModel.appointment)
                        }
                    }
            }
        }
        .background(Color(.cellBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: themeHandler.appColor,
                radius: 0,
                x: 0,
                y: 2)
    }
}

#Preview {
    VStack {
        Spacer()
        AppointmentCell(viewModel: .init(appointment: Appointment()))
            .environmentObject(AppThemeHandler())
        Spacer()
    }
    .padding()
    .background(Color(.background))
}
