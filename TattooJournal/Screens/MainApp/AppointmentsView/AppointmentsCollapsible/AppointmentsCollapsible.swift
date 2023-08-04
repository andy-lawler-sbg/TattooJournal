//
//  AppointmentsCollapsible.swift
//  TattooJournal
//
//  Created by Andy Lawler on 04/08/2023.
//

import SwiftUI

struct AppointmentsCollapsible: View {

    @EnvironmentObject var appointments: Appointments
    @EnvironmentObject var userPreferences: UserPreferences

    @Binding var collapsedTotal: Bool

    var costWithTip: Double {
        let multiplier = 1.0 + (Double(userPreferences.tipAmount.amount) / 100)
        return Double(appointments.cost) * multiplier
    }

    var body: some View {
        VStack(spacing: 10) {
            Button {
                collapsedTotal.toggle()
            } label: {
                HStack(spacing: 0) {
                    Text("Total: ")
                        .font(.caption).bold()
                        .foregroundStyle(userPreferences.appColor)
                    Text("\(userPreferences.currencyString)\(costWithTip, specifier: "%.2f")")
                        .font(.caption)
                        .foregroundStyle(userPreferences.appColor)
                    Image(systemName: collapsedTotal ? "chevron.down" : "chevron.up")
                        .resizable()
                        .frame(width: 10, height: 7)
                        .font(.callout).bold()
                        .foregroundStyle(Color.accentColor)
                        .padding(.leading, 10)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                .background(userPreferences.appColor.opacity(0.2))
                .clipShape(.capsule)
            }

            if !collapsedTotal {
                Text("You will need the above amount to pay for all of your appointments. This price includes the %\(userPreferences.tipAmount.amount) tips.")
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    .padding()
                    .background(Color(.cellBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: .black.opacity(0.05), radius: 5, y: 3)
            }
        }
    }
}


#Preview {
    AppointmentsCollapsible(collapsedTotal: .constant(true))
}
