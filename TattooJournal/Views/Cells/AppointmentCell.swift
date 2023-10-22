//
//  AppointmentCell.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI
import UserNotifications

@Observable
class AppointmentCellViewModel {
    var appointment: Appointment

    init(appointment: Appointment) {
        self.appointment = appointment
    }
}

struct AppointmentCell: View {
    
    @EnvironmentObject var userPreferences: UserPreferences
    var viewModel: AppointmentCellViewModel

    var dateString: String {
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .full
        formatter1.timeStyle = .short
        return formatter1.string(from: viewModel.appointment.date)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 15) {
                if let artistName = viewModel.appointment.artist?.name {
                    Text(artistName)
                        .foregroundColor(userPreferences.appColor)
                        .font(.headline)
                        .fontWeight(.bold)
                }
                if viewModel.appointment.price != "" {
                    HStack(spacing: 10) {
                        Text("\(userPreferences.currencyString)\(viewModel.appointment.price)")
                            .font(.caption).bold()
                            .foregroundStyle(Color.secondary)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 8)
                            .background(Color(.buttonCapsule))
                            .clipShape(.capsule)
                    }
                }
                Spacer()
            }
            if let shopName = viewModel.appointment.shop?.name {
                Text(shopName)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            Text(dateString)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .overlay(alignment: .bottomTrailing) {
            Button {
                viewModel.appointment.notifyMe.toggle()
            } label: {
                Image(systemName: viewModel.appointment.notifyMe ? "bell.fill" : "bell")
                    .resizable()
                    .frame(width: 13, height: 13)
                    .foregroundStyle(viewModel.appointment.notifyMe ? userPreferences.appColor : Color.gray)
                    .padding(6)
                    .background(Color(.buttonCapsule))
                    .clipShape(.circle)
            }
        }
        .padding()
        .background(Color(.cellBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.02), radius: 10)
    }
}

#Preview {
    VStack {
        Spacer()
        AppointmentCell(viewModel: .init(appointment: Appointment()))
            .environmentObject(UserPreferences())
        Spacer()
    }
    .padding()
    .background(Color(.background))
}
