//
//  AppointmentCell.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI

struct AppointmentCell: View {
    
    @EnvironmentObject var userPreferences: UserPreferences
    let appointment: Appointment

    var dateString: String {
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .full
        formatter1.timeStyle = .short
        return formatter1.string(from: appointment.date)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 15) {
                Text(appointment.artist)
                    .foregroundColor(userPreferences.appColor)
                    .font(.headline)
                    .fontWeight(.bold)
                Text("\(userPreferences.currencyString)\(appointment.price)")
                    .font(.caption).bold()
                    .foregroundStyle(Color.secondary)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 8)
                    .background(Color(.buttonCapsule))
                    .clipShape(.capsule)
                Spacer()
            }
            Text(appointment.shop.title)
                .font(.caption)
                .fontWeight(.medium)
            Text(dateString)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .overlay(alignment: .bottomTrailing) {
            Button {
                print("hello world")
            } label: {
                Image(systemName: appointment.notifyMe ? "bell.fill" : "bell")
                    .resizable()
                    .frame(width: 13, height: 13)
                    .foregroundStyle(appointment.notifyMe ? userPreferences.appColor : Color.gray)
                    .padding(6)
                    .background(Color(.buttonCapsule))
                    .clipShape(.circle)
            }
        }
        .padding()
        .background(Color(.cellBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    VStack {
        Spacer()
        AppointmentCell(appointment: MockAppointmentData().appointment)
            .modifier(PreviewEnvironmentObjects())
        Spacer()
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
