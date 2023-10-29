//
//  ArtistsCollectionView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 24/10/2023.
//

import SwiftUI
import SwiftData

@Observable
final class ArtistsCollectionViewModel {
    var artists: [Artist]

    init(artists: [Artist]) {
        self.artists = artists
    }
}

struct ArtistsCollectionView: View {

    var viewModel: ArtistsCollectionViewModel

    let padding: CGFloat = 16
    let columns = [GridItem(.adaptive(minimum:150), spacing: 16), GridItem(.adaptive(minimum:150), spacing: 16)]

    var body: some View {
        VStack {
            VStack {
                Text("Artists")
                    .font(.headline)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("The artists you have booked in with before.")
                    .foregroundStyle(.secondary)
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom, 5)
            .padding(.horizontal)
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.artists, id: \.self) { artist in
                        ArtistView(artist: artist)
                    }
                }
                .padding(.horizontal)
            }
            .background(Color.clear)
        }
        .padding()
    }
}

struct ArtistView: View {

    @EnvironmentObject var themeHandler: AppThemeHandler
    var artist: Artist

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(themeHandler.appColor)
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .offset(y: 5)
                .foregroundStyle(.white.opacity(0.25))
            VStack {
                Text(artist.name)
                ForEach(artist.appointments) { appointment in
                    Text(appointment.date.formatted())
                        .foregroundStyle(.white)
                        .bold()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                        .padding()
                        .multilineTextAlignment(.leading)
                        .minimumScaleFactor(0.5)
                }
            }
        }
        .frame(minHeight: 150)
    }
}

#Preview {
    ArtistsCollectionView(viewModel: .init(artists: [Artist(name: "Andy Lawler")]))
        .environmentObject(AppThemeHandler())
}
