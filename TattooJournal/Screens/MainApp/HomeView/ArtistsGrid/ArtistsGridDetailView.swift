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
    var appointmentToShowDetailView: Appointment?

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
            List {
                ForEach(filteredAppointments) { appointment in
                    AppointmentCell(viewModel: .init(appointment: appointment, cellType: cellType(for: appointment), didTapAppointmentCell: {
                        withAnimation {
                            viewModel.appointmentToShowDetailView = appointment
                        }
                    }))
                    .listRowSeparator(.hidden)
                }.listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            .listRowSpacing(-5)
        }
        .background(Color(.background))
        .navigationTitle(viewModel.artist.name)
        .sheet(item: $viewModel.appointmentToShowDetailView) {
            withAnimation {
                viewModel.appointmentToShowDetailView = nil
            }
        } content: { appointment in
            AppointmentPopUpView(viewModel: .init(appointment: appointment, type: .appointments))
                .presentationDetents([.height(620), .large])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    ArtistsGridDetailView(viewModel: .init(artist: .init()))
}
