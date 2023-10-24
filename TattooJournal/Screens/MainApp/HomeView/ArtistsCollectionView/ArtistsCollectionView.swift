//
//  ArtistsCollectionView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 24/10/2023.
//

import SwiftUI

@Observable
final class ArtistsCollectionViewModel {
    var artists: [Artist]

    init(artists: [Artist]) {
        self.artists = artists
    }
}

struct ArtistsCollectionView: View {
    var viewModel: ArtistsCollectionViewModel

    var body: some View {
        List {
            ForEach(viewModel.artists) { artist in
                ArtistView(artist: artist)
            }
        }
    }
}

struct ArtistView: View {

    @EnvironmentObject var userPreferences: UserPreferences
    var artist: Artist

    private var artistAbbreviation: String {
        let formatter = PersonNameComponentsFormatter()
        guard let components = formatter.personNameComponents(from: artist.name),
              let firstLetter = components.givenName?.first,
              let lastLetter = components.familyName?.first
        else { return "" }
        return "\(firstLetter)\(lastLetter)"
    }

    var body: some View {
        ZStack {
            Text(artistAbbreviation)
                .frame(width: 120, height: 120)
                .scaledToFill()
                .foregroundColor(.white)
            Text(artist.name)
                .foregroundStyle(.white)
                .font(.title3)
                .bold()
                .padding(10)
                .frame(width: 120, height: 120, alignment: .bottomLeading)
                .background(userPreferences.appColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding()
        }
    }
}

#Preview {
    ArtistsCollectionView(viewModel: .init(artists: [Artist(name: "John")]))
}
