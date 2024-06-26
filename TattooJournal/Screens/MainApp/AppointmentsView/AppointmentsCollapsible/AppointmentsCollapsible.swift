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
    let type: AppointmentsCollapsibleType

    init(appointments: [Appointment], 
         type: AppointmentsCollapsibleType = .appointments
    ) {
        self.appointments = appointments
        self.type = type
    }

    enum AppointmentsCollapsibleType {
        case appointments, history

        var enabledState: String {
            switch self {
            case .appointments:
                return "chevron.up"
            case .history:
                return "chevron.down"
            }
        }

        var disabledState: String {
            switch self {
            case .appointments:
                return "chevron.down"
            case .history:
                return "chevron.up"
            }
        }
    }
}

struct AppointmentsCollapsible: View {

    var viewModel: AppointmentsCollapsibleViewModel

    @Query private var queriedUserPreferences: [UserPreferences]
    var userPreferences: UserPreferences {
        queriedUserPreferences.first!
    }

    @EnvironmentObject var themeHandler: AppThemeHandler
    @State var isShowing: Bool = true

    private var costWithTip: Double {
        let multiplier = 1.0 + (Double(userPreferences.tipAmount.intValue) / 100)
        let cost = viewModel.appointments.reduce(into: 0.0) { partialResult, appointment in
            guard let price = Double(appointment.price) else { return }
            partialResult += price
        }
        return cost * multiplier
    }

    var body: some View {
        VStack(spacing: 10) {
            collapsibleButton
            if isShowing {
                unCollapsedInfo
            }
        }
    }

    // MARK: - Collapsible Button

    /// Collapsible Button which can toggle to show the uncollapsed information
    private var collapsibleButton: some View {
        Button {
            withAnimation(.easeIn) {
                isShowing.toggle()
            }
        } label: {
            collapsibleButtonContent
        }
    }

    /// Collapsible Button content which shows the total cost of all appointments
    private var collapsibleButtonContent: some View {
        HStack(spacing: 0) {
            Text(Constants.total)
                .font(.caption).bold()
                .foregroundStyle(themeHandler.appColor)
            Text("\(userPreferences.currency.displayValue)\(costWithTip, specifier: "%.2f")")
                .font(.caption)
                .foregroundStyle(themeHandler.appColor)
            Image(systemName: isShowing ? viewModel.type.enabledState : viewModel.type.disabledState)
                .resizable()
                .frame(width: 10, height: 7)
                .font(.callout.bold())
                .foregroundStyle(themeHandler.appColor)
                .padding(.leading, 10)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .background(themeHandler.appColor.opacity(0.2))
        .clipShape(.capsule)
    }

    // MARK: - UnCollapsed Information

    private var unCollapsedInfoTip: Text {
        Text("This price includes a \(userPreferences.tipAmount.displayValue) tip.")
            .bold()
    }

    private var unCollapsedInfoText: Text {
        switch viewModel.type {
        case .appointments:
            return Text("You will need the above amount to pay for all of your appointments. \(unCollapsedInfoTip)")
        case .history:
           return Text("This is the total amount you have spent on appointments in the past.")
        }
    }

    /// UnCollapsed Information which shows when the button is tapped
    private var unCollapsedInfo: some View {
        unCollapsedInfoText
            .multilineTextAlignment(.center)
            .font(.caption)
            .foregroundColor(themeHandler.appColor)
            .padding(.horizontal)
            .padding()
            .background(themeHandler.appColor.opacity(0.1))
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
    AppointmentsCollapsible(viewModel: .init(appointments: [Appointment()]), isShowing: false)
        .environmentObject(AppThemeHandler())
}
