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
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(appointment.artist)
                    .foregroundColor(.accentColor)
                    .font(.headline)
                    .fontWeight(.bold)
                Text(appointment.shop.title)
                    .font(.body)
                    .fontWeight(.medium)
                Text(dateString)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            VStack (alignment: .trailing, spacing: 5) {
                Text(appointment.design)
                    .font(.body)
                    .fontWeight(.medium)
                Text("\(userPreferences.currencyString)\(appointment.price)")
                    .foregroundColor(.secondary)
                Image(systemName: appointment.notifyMe ? "bell.fill" : "bell")
                    .foregroundColor(appointment.notifyMe ? Color.accentColor : Color.gray)
            }
        }
        .modifier(CellOutline())
    }
}

struct AppointmentCell_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentCell(appointment: MockAppointmentData().appointment)
            .environmentObject(UserPreferences())
    }
}
