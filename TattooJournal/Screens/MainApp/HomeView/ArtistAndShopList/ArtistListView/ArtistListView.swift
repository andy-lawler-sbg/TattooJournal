//
//  ArtistListView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 31/10/2023.
//

import SwiftUI
import SwiftData

struct ArtistListView: View {

    @State private var selectedArtist: Artist?
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Query private var artists: [Artist]

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(artists) { artist in
                        HStack(spacing: 10) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(Color.accentColor)
                                Image(systemName: "paintbrush.pointed.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundStyle(.white)
                                    .padding(8)
                            }
                            .frame(width: 35, height: 35)
                            VStack(spacing: 0) {
                                Text(artist.name)
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                if let instagramHandle = artist.instagramHandle {
                                    Link(destination: URL(string: "https://www.instagram.com/\(instagramHandle)")!) {
                                        Text("@\(instagramHandle)")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }
                            .swipeActions {
                                Button {
                                    withAnimation {
                                        context.delete(artist)
                                        if artists.isEmpty {
                                            dismiss()
                                        }
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                        .symbolVariant(.fill)
                                }

                                Button {
                                    withAnimation {
                                        selectedArtist = artist
                                    }
                                } label: {
                                    Label("Edit", systemImage: "pencil.and.list.clipboard")
                                        .symbolVariant(.fill)
                                } .tint(.yellow)
                            }
                        }
                        .padding(.vertical, 2)
                    }
                } header: {
                    Text("Artists")
                } footer: {
                    Text("These are the artists you've booked in with before.")
                }
                .sheet(item: $selectedArtist) {
                    withAnimation {
                        selectedArtist = nil
                    }
                } content: { artist in
                    ArtistFormView(artist: artist)
                }
            }.navigationTitle("Artists")
        }
    }
}
