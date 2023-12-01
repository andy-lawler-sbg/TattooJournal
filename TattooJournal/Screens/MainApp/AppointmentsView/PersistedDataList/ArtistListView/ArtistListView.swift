//
//  ArtistListView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 31/10/2023.
//

import SwiftUI
import SwiftData

struct ArtistListView: View {

    @State private var shouldShowArtistForm: Bool = false
    @State private var selectedArtist: Artist?
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Query private var artists: [Artist]

    var body: some View {
        NavigationStack {
            VStack {
                if artists.isEmpty {
                    EmptyState(imageName: "paintbrush.pointed.fill", title: "No Artists", description: "You currently have no artists. You can add some here.")
                } else {
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
                            Text("These are the artists you've booked in with before. Tap on an artists @ to view their instagram page.")
                        }
                        .sheet(item: $selectedArtist) {
                            withAnimation {
                                selectedArtist = nil
                            }
                        } content: { artist in
                            ArtistFormView(artist: artist)
                        }
                    }
                }
            }
            .background(Color(.background))
            .navigationTitle("Artists")
            .overlay(alignment: .bottomTrailing) {
                Button {
                    withAnimation {
                        shouldShowArtistForm = true
                    }
                } label: {
                    NavBarItem(imageName: "plus",
                               circleSize: 60,
                               imageSize: 20,
                               shadowOpacity: 0.3,
                               shadowRadius: 10)
                    .padding(30)
                }
                .onTapGesture(perform: Haptics.shared.successHaptic)
            }
            .sheet(isPresented: $shouldShowArtistForm) {
                ArtistForm()
                    .presentationDetents([.height(270), .medium])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}
