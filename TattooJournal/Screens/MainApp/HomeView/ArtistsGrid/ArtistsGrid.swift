//
//  ArtistsGrid.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/11/2023.
//

import SwiftUI
import SwiftData

struct ArtistsGrid: View {

    @EnvironmentObject private var themeHandler: AppThemeHandler
    @Environment(\.modelContext) private var context

    @State private var artistDeleteAlert = false

    @Query private var artists: [Artist]
    @Query private var images: [TattooImage]

    private func image(for artist: Artist) -> Image? {
        guard let image = images.filter({ $0.appointment?.artist == artist }).first, 
              let uiImage = UIImage(data: image.image) else {
            return nil
        }
        return Image(uiImage: uiImage)
    }

    private func hasImage(for artist: Artist) -> Bool {
        image(for: artist) != nil
    }
    
    var emptyTextView: some View {
        Label("You have no artists. You might want to add some?", systemImage: "person.slash.fill")
            .font(.caption)
            .foregroundColor(themeHandler.appColor)
            .frame(maxWidth: .infinity)
            .padding()
            .padding(.horizontal)
            .background(themeHandler.appColor.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding()
    }

    var body: some View {
        ScrollView {
            if artists.isEmpty {
                emptyTextView
            } else {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 7) {
                    ForEach(artists) { artist in
                        NavigationLink {
                            ArtistsGridDetailView(viewModel: .init(artist: artist))
                        } label: {
                            VStack {
                                Text(artist.name)
                                    .font(.callout)
                                    .bold()
                                    .foregroundStyle(Color(.oppositeStyle))
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                ZStack {
                                    if let image = image(for: artist) {
                                        image
                                            .resizable()
                                    } else {
                                        RoundedRectangle(cornerRadius: 10)
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .padding(40)
                                            .foregroundStyle(.white)
                                    }
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .aspectRatio(1, contentMode: .fit)
                                .overlay(alignment: .topTrailing) {
                                    ZStack {
                                        Circle()
                                            .frame(width: 30, height: 30)
                                            .foregroundStyle(Color(.cellBackground))
                                        Image(systemName: "xmark.bin.fill")
                                            .imageScale(.small)
                                            .frame(width: 44, height: 44)
                                            .foregroundStyle(themeHandler.appColor)
                                    }
                                    .onTapGesture {
                                        withAnimation {
                                            artistDeleteAlert = true
                                        }
                                    }
                                    .alert("Are you sure?", isPresented: $artistDeleteAlert, actions: {
                                        Button {
                                            artistDeleteAlert = false
                                        } label: {
                                            Text("Cancel")
                                        }.tint(.red)
                                        Button {
                                            artistDeleteAlert = false
                                            context.delete(artist)
                                        } label: {
                                            Text("Delete")
                                                .bold()
                                        }.tint(themeHandler.appColor)
                                    }, message: {
                                        Text("Are you sure you want to delete \(artist.name.lowercased())?")
                                    })
                                }
                            }
                        }
                    }
                }.padding(.horizontal, 7)
            }
        }
    }
}

#Preview {
    ArtistsGrid()
}
