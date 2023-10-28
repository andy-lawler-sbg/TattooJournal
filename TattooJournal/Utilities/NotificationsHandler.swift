//
//  NotificationsHandler.swift
//  TattooJournal
//
//  Created by Andrew Lawler on 22/10/2023.
//

import Foundation
import UserNotifications

final class NotificationsHandler: ObservableObject {

    private let notificationCenter: UNUserNotificationCenter
    private let calendar: Calendar

    init(notificationCenter: UNUserNotificationCenter = .current(), calendar: Calendar = .current) {
        self.notificationCenter = notificationCenter
        self.calendar = calendar
    }

    // MARK: - Public Methods

    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("🔔 Successfully Requested Notification Permissions 🔔")
            } else if let error = error {
                print("🔕 Failed To Get Notification Permissions: \(error.localizedDescription) 🔕")
            }
        }
    }

    func scheduleNotifications(for appointment: Appointment) {
        let notificationsToSchedule: [AppointmentNotificationType] = [.morningReminder, .timeReminder]

        for type in notificationsToSchedule {
            guard let content = notificationContent(with: type, for: appointment) else { return }
            let identifier = appointment.id + type.rawValue
            let trigger = type.trigger(for: appointment, calendar: calendar)
            let request = UNNotificationRequest(identifier: identifier,
                                                content: content,
                                                trigger: trigger)

            notificationCenter.add(request) { (error) in
                if let error {
                    print("🔕 Failed To Schedule Notification. For: \(appointment.date). With: \(error.localizedDescription). 🔕")
                } else {
                    print("🔔 Successfully Scheduled Notification. For: \(appointment.date) 🔔")
                }
            }
        }
    }

    func deleteScheduledNotification(for appointment: Appointment) {
        var identifiers = [String]()
        for type in AppointmentNotificationType.allCases {
            identifiers.append(appointment.id + type.rawValue)
        }
        notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
    }

    // MARK: - Private Helper Methods

    private func notificationContent(with type: AppointmentNotificationType, for appointment: Appointment) -> UNMutableNotificationContent? {
        let content = UNMutableNotificationContent()
        content.title = "TattooJournal"
        content.subtitle = type.subtitle
        content.body = type.body(for: appointment)
        content.sound = type.sound
        return content
    }

    enum AppointmentNotificationType: String, CaseIterable {
        case morningReminder, timeReminder

        var subtitle: String {
            switch self {
            case .morningReminder:
                return "Appointment Today"
            case .timeReminder:
                return "Appointment Starting Now"
            }
        }

        var sound: UNNotificationSound {
            switch self {
            case .morningReminder:
                return .default
            case .timeReminder:
                return .defaultCritical
            }
        }

        func body(for appointment: Appointment) -> String {
            switch self {
            case .morningReminder:
                guard let artistName = appointment.artist?.name else {
                    return "You have an appointment today at: \(appointment.date.formatted(date: .omitted, time: .shortened))"
                }
                return "You have an appointment today with \(artistName.lowercased().capitalized) at \(appointment.date.formatted(date: .omitted, time: .shortened))"
            case .timeReminder:
                guard let artistName = appointment.artist?.name else {
                    return "You have an appointment today at: \(appointment.date.formatted(date: .omitted, time: .shortened))"
                }
                return "You have an appointment with \(artistName.lowercased().capitalized) starting now."
            }
        }

        func trigger(for appointment: Appointment, calendar: Calendar) -> UNNotificationTrigger {
            var dateComponents = calendar.dateComponents(in: .current, from: appointment.date)
            dateComponents.quarter = 1

            switch self {
            case .morningReminder:
                dateComponents.hour = 8
                dateComponents.minute = 0
                dateComponents.second = 0
                return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            case .timeReminder:
                return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            }
        }
    }
}
