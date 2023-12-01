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
        Text("Welcome")
    }

    var message: Text? {
        Text("Below you will find ways to store memories and find out more about your tattoos.")
    }
}
