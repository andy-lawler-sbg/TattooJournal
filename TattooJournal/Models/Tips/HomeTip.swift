//
//  HomeTip.swift
//  TattooJournal
//
//  Created by Andy Lawler on 11/08/2023.
//

import SwiftUI
import TipKit

struct HomeTip: Tip {
    var title: Text {
        Text("Hello")
    }

    var message: Text? {
        Text("Welcome to TattooJournal. Follow the steps below to get started.")
    }

    var asset: Image? {
        Image(systemName: "hand.wave")
    }
}
