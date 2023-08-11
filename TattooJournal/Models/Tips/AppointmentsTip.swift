//
//  AppointmentsTip.swift
//  TattooJournal
//
//  Created by Andy Lawler on 11/08/2023.
//

import SwiftUI
import TipKit

struct AppointmentsTip: Tip {
    var title: Text {
        Text("Upcoming appointments")
    }

    var message: Text? {
        Text("This list shows you your upcoming appointments. Swipe to delete any appointments you no longer have booked.")
    }

    var asset: Image? {
        Image(systemName: "calendar.circle")
    }
}
