//
//  CostView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI

struct CostView: View {

    @EnvironmentObject var appointments: Appointments
    @EnvironmentObject var userPreferences: UserPreferences

    var body: some View {
        Button {
            print("💰 Cost View Button pressed")
        } label: {
            Text("You have spent: \(userPreferences.currencyString)\(appointments.cost, specifier: "%.2f")")
        }
        .buttonStyle(.bordered)
        .tint(.accentColor)
        .controlSize(.large)
    }
}

struct CostView_Previews: PreviewProvider {
    static var previews: some View {
        CostView()
            .modifier(PreviewEnvironmentObjects())
    }
}
