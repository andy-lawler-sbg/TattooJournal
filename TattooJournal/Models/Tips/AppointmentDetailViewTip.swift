//
//  AppointmentDetailViewTip.swift
//  TattooJournal
//
//  Created by Andy Lawler on 02/11/2023.
//

import SwiftUI
import TipKit

struct AppointmentDetailViewTip: Tip {

    var type: AppointmentPopUpType

    var title: Text {
        switch type {
        case .appointments:
            return Text("Remember")
        case .history:
            return Text("")
        }
    }

    var message: Text? {
        switch type {
        case .appointments:
            return Text("Remember, you can edit these values by swiping on your appointment in the Appointments page.")
        case .history:
            return nil
        }
    }

    var asset: Image? {
        Image(systemName: "arrowshape.turn.up.backward.2.fill")
    }
}


