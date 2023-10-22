//
//  NotificationsTrigger.swift
//  TattooJournal
//
//  Created by Andrew Lawler on 22/10/2023.
//

import Foundation
import UserNotifications

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
