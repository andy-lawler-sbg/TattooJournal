//
//  AppointmentsTip.swift
//  TattooJournal
//
//  Created by Andy Lawler on 11/08/2023.
//

import SwiftUI
import TipKit

struct AppointmentsTip: Tip {

    var hasAppointments: Bool

    var title: Text {
        Text("Upcoming appointments")
    }

    var message: Text? {
        if hasAppointments {
            return Text("This list shows you your upcoming appointments. Swipe to delete any appointments you no longer have booked.")
        } else {
            return Text("This list will show upcoming appointments. Add some appointments you have coming up.")
        }
    }

    var asset: Image? {
        Image(systemName: "calendar.circle")
    }
}
