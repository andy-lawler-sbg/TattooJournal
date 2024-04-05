//
//  Charts.swift
//  TattooJournal
//
//  Created by Andy Lawler on 25/11/2023.
//

import Foundation
import SwiftUI
import SwiftData
import Charts

struct Charts: View {
    @EnvironmentObject private var themeHandler: AppThemeHandler
    @Query private var appointments: [Appointment]
    @Query private var images: [TattooImage]

    var tattooDates: [Date] {
        let appointmentDates = appointments.map { $0.date }
        let imageDates = images.filter { image in
            !appointments.contains { appointment in
                appointment.image == image
            }
        }.map { $0.date }
        let dates = appointmentDates + imageDates
        return dates.sorted()
    }

    var spendingChart: some View {
        VStack(spacing: 10) {
            Text("Spending")
                .font(.callout)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.primary)
                .padding(.top, 10)
            Chart(appointments) {
                LineMark(
                    x: .value("Date", $0.date.formatted()),
                    y: .value("Price", Double($0.price) ?? 0)
                )
                PointMark(x: .value("Date", $0.date.formatted()),
                          y: .value("Price", Double($0.price) ?? 0)
                ).foregroundStyle(themeHandler.appColor)
            }
            .background(Color.clear)
            .padding(.bottom)
        }
        .padding(.horizontal)
        .frame(minWidth: 250, minHeight: 150, maxHeight: 200)
        .background(Color(.cellBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    var tattooDate: some View {
        VStack(spacing: 10) {
            Text("Tattoos")
                .font(.callout)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.primary)
                .padding(.top, 10)
            Chart(tattooDates, id: \.self) { tattooDate in
                PointMark(y: .value("Date", tattooDate))
                    .foregroundStyle(themeHandler.appColor)
            }
            .background(Color.clear)
            .padding(.bottom)
        }
        .chartXAxisLabel("Tattoos")
        .padding(.horizontal)
        .frame(minWidth: 250, minHeight: 150, maxHeight: 200)
        .background(Color(.cellBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                spendingChart
                tattooDate
            }
            .padding(.horizontal, 7)
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    Charts()
}
