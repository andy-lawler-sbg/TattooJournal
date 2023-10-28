//
//  ReviewAppointmentView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 28/10/2023.
//

import SwiftUI

struct ReviewAppointmentView: View {

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeHandler: AppThemeHandler

    var viewModel: ReviewAppointmentViewModel

    var body: some View {
        NavigationStack {
            VStack {
                descriptionText
                listView
                Spacer()
            }
            .navigationTitle(Constants.title)
            .background(Color(.background))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text(Constants.closeText)
                            .foregroundStyle(themeHandler.appColor)
                            .padding(.vertical, 7)
                            .padding(.horizontal)
                            .background(themeHandler.appColor.opacity(0.15))
                            .clipShape(.capsule)
                    }
                }
            }
        }
    }

    // MARK: - Views

    private var descriptionText: some View {
        Text(Constants.description)
            .frame(maxWidth: .infinity)
            .padding()
            .multilineTextAlignment(.center)
            .font(.body)
            .foregroundStyle(.primary)
    }

    private var listView: some View {
        List {
            ForEach(viewModel.appointments) { appointment in
                VStack(alignment: .leading, spacing: 5) {
                    Text(appointment.artist?.name ?? "")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(themeHandler.appColor)
                    Text(formattedDate(for: appointment.date))
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                    Text(appointment.design)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 10)
                    StarRatingView(rating: .constant(1))
                }
            }
        }
    }

    // MARK: - Helper Methods

    private func formattedDate(for date: Date) -> String {
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .full
        formatter1.timeStyle = .short
        return formatter1.string(from: date)
    }
}

private extension ReviewAppointmentView {
    enum Constants {
        static let title = "Review"
        static let closeText = "Close"
        static let description = "You have had some appointments since you last entered the app. Would you like to review how they went?"
    }
}
