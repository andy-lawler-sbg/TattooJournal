//
//  AppointmentSpendingChart.swift
//  TattooJournal
//
//  Created by Andrew Lawler on 23/10/2023.
//

import Foundation
import SwiftUI
import SwiftData
import Charts

@Observable
final class AppointmentSpendingChartViewModel {
    var appointments: [Appointment]

    init(appointments: [Appointment]) {
        self.appointments = appointments
    }
}

struct AppointmentSpendingChart: View {

    @EnvironmentObject var userPreferences: UserPreferences
    var viewModel: AppointmentSpendingChartViewModel

    var body: some View {
        VStack(spacing: 5) {
            Text("Spending")
                .font(.headline)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            Chart(viewModel.appointments) {
                LineMark(
                    x: .value("Date", $0.date),
                    y: .value("Price", Double($0.price) ?? 0)
                )
                .foregroundStyle(userPreferences.appColor)
            }
            .background(Color.clear)
            .frame(maxHeight: 150)
        }
        .padding(15)
        .background(Color(.cellBackground))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding()
    }
}

#Preview {
    VStack {
        AppointmentSpendingChart(viewModel: .init(appointments: [Appointment()]))
            .environmentObject(UserPreferences())
    }
}