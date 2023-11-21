//
//  ReviewAppointmentView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 28/10/2023.
//

import SwiftUI
import SwiftData
import PhotosUI

struct ReviewAppointmentView: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var themeHandler: AppThemeHandler

    @State private var imageSelected: PhotosPickerItem? = nil
    @State private var appointmentForSelectedImage: Appointment? = nil

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
            .task(id: imageSelected) {
                if let data = try? await imageSelected?.loadTransferable(type: Data.self) {
                    let image = TattooImage(image: data, appointment: viewModel.appointments.first)
                    withAnimation {
                        context.insert(image)
                        // add tattooImage and link to Appointment
                        imageSelected = nil
                        appointmentForSelectedImage = nil
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
                    if let image = appointment.image, let uiImage = UIImage(data: image.image) {
                        PhotosPicker(selection: $imageSelected,
                                     matching: .images,
                                     photoLibrary: .shared()) {
                            ZStack {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                Image(systemName: "square.and.arrow.up")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30)
                                    .foregroundStyle(themeHandler.appColor)
                                    .bold()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                                    .padding(10)
                            }
                            .frame(width: 100)
                        }
                    } else {
                        PhotosPicker(selection: $imageSelected,
                                     matching: .images,
                                     photoLibrary: .shared()) {
                            Label("Add Image", systemImage: "square.and.arrow.up")
                                .foregroundStyle(themeHandler.appColor)
                        }
                    }
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
