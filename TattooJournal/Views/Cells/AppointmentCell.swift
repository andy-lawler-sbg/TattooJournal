//
//  AppointmentCell.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI
import SwiftData

@Observable
class AppointmentCellViewModel {

    var appointment: Appointment
    var cellType: AppointmentCellType

    var reviewAccessoryIconTap: (() -> Void)?
    var didTapAppointmentCell: (() -> Void)?

    var accessoryToShow: AppointmentCellAccessory {
        switch cellType {
        case .upcoming:
            return .notificationBell
        case .history:
            return .starRating
        }
    }

    init(appointment: Appointment, 
         cellType: AppointmentCellType = .upcoming,
         reviewAccessoryIconTap: (() -> Void)? = nil,
         didTapAppointmentCell: (() -> Void)? = nil
    ) {
        self.appointment = appointment
        self.cellType = cellType
        self.reviewAccessoryIconTap = reviewAccessoryIconTap
        self.didTapAppointmentCell = didTapAppointmentCell
    }

    enum AppointmentCellType {
        case upcoming, history
    }

    enum AppointmentCellAccessory {
        case notificationBell, starRating
    }
}

struct AppointmentCell: View {

    @EnvironmentObject var themeHandler: AppThemeHandler
    @EnvironmentObject var notificationsHandler: NotificationsHandler
    @Query private var queriedUserPreferences: [UserPreferences]

    private var userPreferences: UserPreferences {
        queriedUserPreferences.first!
    }

    private var dateString: String {
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .full
        formatter1.timeStyle = .short
        return formatter1.string(from: viewModel.appointment.date)
    }

    var viewModel: AppointmentCellViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 15) {
                Text(viewModel.appointment.artist?.name ?? "No Artist")
                    .foregroundStyle(themeHandler.appColor)
                    .font(.headline)
                    .fontWeight(.bold)
                HStack(spacing: 10) {
                    if !viewModel.appointment.price.isEmpty {
                        Text("\(userPreferences.currency.displayValue)\(viewModel.appointment.price)")
                            .font(.caption).bold()
                            .foregroundStyle(Color.secondary)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 8)
                            .background(Color(.buttonCapsule))
                            .clipShape(.capsule)
                    }
                    Text(viewModel.appointment.bodyPart)
                        .font(.caption).bold()
                        .foregroundStyle(Color.white)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 8)
                        .background(themeHandler.appColor.opacity(0.75))
                        .clipShape(.capsule)
                }
                Spacer()
            }
            Text(viewModel.appointment.shop?.name ?? "No Shop")
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.bottom, 3)
            Text(dateString)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.bottom, 3)
            Text(viewModel.appointment.design)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding()
        .overlay(alignment: .bottomTrailing) {
            switch viewModel.accessoryToShow {
            case .notificationBell:
                Image(systemName: viewModel.appointment.notifyMe ? "bell.fill" : "bell")
                    .resizable()
                    .frame(width: 13, height: 13)
                    .foregroundStyle(viewModel.appointment.notifyMe ? themeHandler.appColor : Color.gray)
                    .padding(6)
                    .background(Color(.buttonCapsule))
                    .clipShape(.circle)
                    .frame(width: 50, height: 50, alignment: .bottomTrailing)
                    .background(Color(.cellBackground))
                    .padding(10)
                    .onTapGesture {
                        viewModel.appointment.notifyMe.toggle()
                        if viewModel.appointment.notifyMe {
                            notificationsHandler.scheduleNotifications(for: viewModel.appointment)
                        } else {
                            notificationsHandler.deleteScheduledNotification(for: viewModel.appointment)
                        }
                    }
            case .starRating:
                Image(systemName: true ? "star.fill" : "star")
                    .resizable()
                    .frame(width: 13, height: 13)
                    .foregroundStyle(viewModel.appointment.notifyMe ? themeHandler.appColor : Color.gray)
                    .padding(6)
                    .background(Color(.buttonCapsule))
                    .clipShape(.circle)
                    .frame(width: 50, height: 50, alignment: .bottomTrailing)
                    .background(Color(.cellBackground))
                    .padding(10)
                    .onTapGesture {
                        viewModel.reviewAccessoryIconTap?()
                    }
            }
        }
        .background(Color(.cellBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: themeHandler.appColor,
                radius: 0,
                x: 0,
                y: 2)
        .onTapGesture {
            viewModel.didTapAppointmentCell?()
        }
    }
}

#Preview {
    VStack {
        Spacer()
        AppointmentCell(viewModel: .init(appointment: Appointment()))
            .environmentObject(AppThemeHandler())
        Spacer()
    }
    .padding()
    .background(Color(.background))
}
