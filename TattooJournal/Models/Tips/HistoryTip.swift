//
//  HistoryTip.swift
//  TattooJournal
//
//  Created by Andy Lawler on 11/08/2023.
//

import SwiftUI
import TipKit

struct HistoryTip: Tip {
    var title: Text {
        Text("Past Appointments")
    }

    var message: Text? {
        Text("This page shows you the tattoo sessions you have completed. If you did in-fact miss an appointment feel free to swipe to delete it.")
    }

    var asset: Image? {
        Image(systemName: "arrowshape.turn.up.backward.badge.clock")
    }
}

