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
    @State private var starSelected: Int = 1

    @Query private var tattooImages: [TattooImage]

    var viewModel: ReviewAppointmentViewModel

    var body: some View {
        NavigationStack {
            listView
                .navigationTitle(formattedDateWithoutTime(for: viewModel.appointment.date))
                .background(Color(.background))
                .task(id: imageSelected) {
                    if let data = try? await imageSelected?.loadTransferable(type: Data.self) {
                        let images = tattooImages.filter { $0.appointment == viewModel.appointment }
                        images.forEach { context.delete($0) }

                        let image = TattooImage(image: data, appointment: viewModel.appointment)
                        withAnimation {
                            context.insert(image)
                            // add tattooImage and link to Appointment
                            imageSelected = nil
                            appointmentForSelectedImage = nil
                        }
                    }
                }
                .task(id: starSelected) {
                    let review = Review(rating: starSelected, appointment: viewModel.appointment)
                    context.insert(review)
                }
        }
        .overlay(
            Button {
                dismiss()
            } label: {
               XMarkButton()
            }, alignment: .topTrailing
        )
    }

    // MARK: - Views

    private var listView: some View {
        Form {
            Section {
                if let artistName = viewModel.appointment.artist?.name {
                    Text(artistName)
                        .font(.body)
                        .bold()
                }
                Text(viewModel.appointment.design)
                    .font(.body)
                StarRatingView(rating: $starSelected)
                if let image = viewModel.appointment.image, let uiImage = UIImage(data: image.image) {
                    PhotosPicker(selection: $imageSelected,
                                 matching: .images,
                                 photoLibrary: .shared()) {
                        ZStack {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .frame(width: 200)
                        .overlay(alignment: .bottomTrailing) {
                            ZStack {
                                Circle()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(Color(.cellBackground))
                                Image(systemName: "square.and.arrow.up")
                                    .imageScale(.small)
                                    .frame(width: 44, height: 44)
                                    .foregroundStyle(Color(.oppositeStyle))
                            }
                        }
                    }
                } else {
                    PhotosPicker(selection: $imageSelected,
                                 matching: .images,
                                 photoLibrary: .shared()) {
                        Label("Add Image", systemImage: "square.and.arrow.up")
                            .foregroundStyle(themeHandler.appColor)
                    }
                }
            } header: {
                Text(Constants.header)
            } footer: {
                Text(Constants.footer)
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

    private func formattedDateWithoutTime(for date: Date) -> String {
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .full
        formatter1.timeStyle = .none
        return formatter1.string(from: date)
    }
}

private extension ReviewAppointmentView {
    enum Constants {
        static let title = "Review"
        static let closeText = "Close"
        static let header = "Review"
        static let footer = "You have had an appointment since you last visited the app, would you like to review it?"
    }
}
