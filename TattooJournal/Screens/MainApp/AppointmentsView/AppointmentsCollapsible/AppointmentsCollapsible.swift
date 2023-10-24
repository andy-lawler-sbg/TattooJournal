//
//  AppointmentsCollapsible.swift
//  TattooJournal
//
//  Created by Andy Lawler on 04/08/2023.
//

import SwiftUI
import SwiftData

@Observable
final class AppointmentsCollapsibleViewModel {

    var appointments: [Appointment]

    init(appointments: [Appointment]) {
        self.appointments = appointments
    }
}

struct AppointmentsCollapsible: View {

    var viewModel: AppointmentsCollapsibleViewModel

    @EnvironmentObject var userPreferences: UserPreferences
    @Binding var collapsed: Bool

    private var costWithTip: Double {
        let multiplier = 1.0 + (Double(userPreferences.tipAmount.amount) / 100)
        let cost = viewModel.appointments.reduce(into: 0.0) { partialResult, appointment in
            guard let price = Double(appointment.price) else { return }
            partialResult += price
        }
        return cost * multiplier
    }

    var body: some View {
        VStack(spacing: 10) {
            collapsibleButton
            if !collapsed {
                unCollapsedInfo
            }
        }
    }

    // MARK: - Collapsible Button

    /// Collapsible Button which can toggle to show the uncollapsed information
    private var collapsibleButton: some View {
        Button {
            collapsed.toggle()
        } label: {
            collapsibleButtonContent
        }
    }

    /// Collapsible Button content which shows the total cost of all appointments
    private var collapsibleButtonContent: some View {
        HStack(spacing: 0) {
            Text(Constants.total)
                .font(.caption).bold()
                .foregroundStyle(userPreferences.appColor)
            Text("\(userPreferences.currencyString)\(costWithTip, specifier: "%.2f")")
                .font(.caption)
                .foregroundStyle(userPreferences.appColor)
            Image(systemName: collapsed ? "chevron.down" : "chevron.up")
                .resizable()
                .frame(width: 10, height: 7)
                .font(.callout.bold())
                .foregroundStyle(userPreferences.appColor)
                .padding(.leading, 10)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .background(userPreferences.appColor.opacity(0.2))
        .clipShape(.capsule)
    }

    // MARK: - UnCollapsed Information

    private var unCollapsedInfoTip: Text {
        Text("This price includes a \(userPreferences.tipAmount.amount)% tip.")
            .bold()
    }

    /// UnCollapsed Information which shows when the button is tapped
    private var unCollapsedInfo: some View {
        Text("You will need the above amount to pay for all of your appointments. \(unCollapsedInfoTip)")
            .multilineTextAlignment(.center)
            .font(.caption)
            .foregroundColor(userPreferences.appColor)
            .padding(.horizontal)
            .padding()
            .background(userPreferences.appColor.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: .black.opacity(0.05), radius: 5, y: 3)
    }
}

// MARK: - Constants

private extension AppointmentsCollapsible {
    enum Constants {
        static let total = "Total: "
    }
}

// MARK: - Preview

#Preview {
    AppointmentsCollapsible(viewModel: .init(appointments: [Appointment()]), collapsed: .constant(false))
        .environmentObject(UserPreferences())}
