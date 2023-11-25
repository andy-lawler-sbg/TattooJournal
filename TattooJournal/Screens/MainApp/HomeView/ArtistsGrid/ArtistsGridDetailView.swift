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

    func cellType(for appointment: Appointment) -> AppointmentCellViewModel.AppointmentCellType {
        if appointment.date > .now {
            return .upcoming
        } else {
            return .history
        }
    }

    var body: some View {
        NavigationStack {
            AppointmentListView(viewModel: .init(appointments: filteredAppointments))
        }
        .background(Color(.background))
        .navigationTitle(viewModel.artist.name)
    }
}

#Preview {
    ArtistsGridDetailView(viewModel: .init(artist: .init()))
}
