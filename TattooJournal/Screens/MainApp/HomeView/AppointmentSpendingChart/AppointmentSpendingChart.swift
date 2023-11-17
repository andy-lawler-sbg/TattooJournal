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

struct AppointmentSpendingChart: View {

    @EnvironmentObject var themeHandler: AppThemeHandler
    var viewModel: AppointmentSpendingChartViewModel

    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Spending")
                    .font(.body)
                    .bold()
                Spacer()
            }
            .padding(.horizontal, 6)
            .padding(.bottom, 4)
            Chart(viewModel.appointments) {
                LineMark(
                    x: .value("Date", $0.date.formatted()),
                    y: .value("Price", Double($0.price) ?? 0)
                )
                PointMark(x: .value("Date", $0.date.formatted()),
                          y: .value("Price", Double($0.price) ?? 0)
                ).foregroundStyle(themeHandler.appColor)
            }
            .background(Color.clear)
            .frame(maxHeight: 150)
            .padding()
            .background(Color(.cellBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
        }
        .padding(.horizontal, 5)
    }
}

#Preview {
    VStack {
        AppointmentSpendingChart(viewModel: .init(appointments: [Appointment()]))
            .environmentObject(AppThemeHandler())
    }
}
