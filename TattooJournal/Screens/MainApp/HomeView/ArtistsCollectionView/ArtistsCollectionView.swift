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
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(viewModel.artists, id: \.self) { artist in
                    ArtistView(artist: artist)
                }
            }
            .padding(.horizontal)
        }
        .frame(maxHeight: 300)
        .background(Color.clear)
    }
}

struct ArtistView: View {

    @EnvironmentObject var userPreferences: UserPreferences
    var artist: Artist

    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(minHeight: 150)
            .foregroundStyle(userPreferences.appColor)
    }
}

#Preview {
    ArtistsCollectionView(viewModel: .init(artists: [Artist(name: "Andy Lawler")]))
        .environmentObject(UserPreferences())
}
