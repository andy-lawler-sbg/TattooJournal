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
        Text("Welcome home")
    }

    var message: Text? {
        Text("Below you will find ways to store your tattoo memories and view more details about your sessions.")
    }
}
