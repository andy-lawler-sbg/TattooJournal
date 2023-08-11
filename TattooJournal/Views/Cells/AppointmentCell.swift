//
//  AppointmentCell.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI
import UserNotifications

struct AppointmentCell: View {
    
    @EnvironmentObject var userPreferences: UserPreferences
    let appointment: Appointment

    var dateString: String {
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .full
        formatter1.timeStyle = .short
        return formatter1.string(from: appointment.date)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 15) {
                Text(appointment.artist)
                    .foregroundColor(userPreferences.appColor)
                    .font(.headline)
                    .fontWeight(.bold)
                Text("\(userPreferences.currencyString)\(appointment.price)")
                    .font(.caption).bold()
                    .foregroundStyle(Color.secondary)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 8)
                    .background(Color(.buttonCapsule))
                    .clipShape(.capsule)
                Spacer()
            }
            Text(appointment.shop.title)
                .font(.caption)
                .fontWeight(.medium)
            Text(dateString)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .overlay(alignment: .bottomTrailing) {
            Button {
//                let content = UNMutableNotificationContent()
//                content.title = "\(appointment.artist) - \(appointment.shop)"
//                content.subtitle = "\(appointment.date)"
//                content.sound = UNNotificationSound.default
//
//                // show this notification five seconds from now
//                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//
//                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//
//                UNUserNotificationCenter.current().add(request)
            } label: {
                Image(systemName: appointment.notifyMe ? "bell.fill" : "bell")
                    .resizable()
                    .frame(width: 13, height: 13)
                    .foregroundStyle(appointment.notifyMe ? userPreferences.appColor : Color.gray)
                    .padding(6)
                    .background(Color(.buttonCapsule))
                    .clipShape(.circle)
            }
        }
        .padding()
        .background(Color(.cellBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.accentColor)
        )
    }
}

#Preview {
    VStack {
        Spacer()
        AppointmentCell(appointment: MockAppointmentData().appointment)
            .modifier(PreviewEnvironmentObjects())
        Spacer()
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
