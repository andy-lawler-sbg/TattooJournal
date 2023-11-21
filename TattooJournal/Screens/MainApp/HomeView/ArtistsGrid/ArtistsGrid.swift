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

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 7) {
                ForEach(artists) { artist in
                    ZStack {
                        if let image = image(for: artist) {
                            image
                                .resizable()
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .background(.white)
                                .foregroundStyle(LinearGradient(colors: [themeHandler.appColor, themeHandler.appColor.opacity(0.75)],
                                                                startPoint: .top,
                                                                endPoint: .bottom))
                        }
                        VStack {
                            Spacer()
                            VStack {
                                Text(artist.name)
                                    .bold()
                                    .font(hasImage(for: artist) ? .caption2 : .largeTitle)
                                    .foregroundStyle(hasImage(for: artist) ? themeHandler.appColor : .white)
                                    .multilineTextAlignment(hasImage(for: artist) ? .center : .trailing)
                                    .frame(maxWidth: .infinity, alignment: hasImage(for: artist) ? .center : .trailing)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(5)
                            .background(Color(.cellBackground).opacity(hasImage(for: artist) ? 0.75 : 0))
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .aspectRatio(1, contentMode: .fit)
                }
            }.padding(.horizontal, 7)
        }
    }
}

#Preview {
    ArtistsGrid()
}
