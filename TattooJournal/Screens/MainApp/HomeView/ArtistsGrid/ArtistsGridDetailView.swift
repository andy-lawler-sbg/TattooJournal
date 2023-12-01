//
//  ArtistsGridDetailView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/11/2023.
//

import SwiftUI
import SwiftData

@Observable
final class ArtistsGridDetailViewModel {
    let artist: Artist

    init(artist: Artist) {
        self.artist = artist
    }
}

struct ArtistsGridDetailView: View {

    @Bindable var viewModel: ArtistsGridDetailViewModel

    @Query private var appointments: [Appointment]
    private var filteredAppointments: [Appointment] {
        appointments.filter { $0.artist == viewModel.artist }
    }

    @Query private var images: [TattooImage]
    private var filteredImages: [TattooImage] {
        images.filter({ $0.appointment?.artist == viewModel.artist })
    }

    func cellType(for appointment: Appointment) -> AppointmentCellViewModel.AppointmentCellType {
        if appointment.date > .now {
            return .upcoming
        } else {
            return .history
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(filteredImages) { tattooImage in
                        if let uiImage = UIImage(data: tattooImage.image) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }.padding(.horizontal)
            }
            AppointmentListView(viewModel: .init(appointments: filteredAppointments))
        }
        .background(Color(.background))
        .navigationTitle(viewModel.artist.name)
    }
}

#Preview {
    ArtistsGridDetailView(viewModel: .init(artist: .init()))
}
