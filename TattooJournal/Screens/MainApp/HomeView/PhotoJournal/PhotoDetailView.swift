//
//  PhotoDetailView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 18/11/2023.
//

import SwiftData
import SwiftUI

struct PhotoDetailView: View {
    
    let image: TattooImage

    @Query private var queriedUserPreferences: [UserPreferences]
    private var userPreferences: UserPreferences {
        queriedUserPreferences.first!
    }

    var body: some View {
        NavigationStack {
            VStack {
                if let uiImage = UIImage(data: image.image) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .opacity(0.25)
                        .frame(maxWidth: .infinity, maxHeight: 300)
                        .ignoresSafeArea(edges: [.top])
                }
                if let pageContent {
                    List {
                        Section {
                            ForEach(pageContent, id: \.id) { page in
                                page
                            }
                        }
                    }                
                    .padding(.horizontal)
                    .scrollIndicators(.hidden)
                }
                Spacer()

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Image Details")
            .navigationBarTitleDisplayMode(.large)
            .background(Color(.background))
        }
        .background(Color(.background))
    }

    var pageContent: [SettingsItemView<Text>]? {
        guard let appointment = image.appointment else { return nil }
        var items: [SettingsItemView<Text>] = []
        items.append(SettingsItemView(itemView: Text(appointment.date.formatted()), imageName: "calendar", backgroundColor: .red))
        if let artist = appointment.artist {
            items.append(SettingsItemView(itemView: Text(artist.name), imageName: "person.fill", backgroundColor: .mint))
        }
        items.append(SettingsItemView(itemView: Text(appointment.price), imageName: "\(userPreferences.currency.rawValue)sign", backgroundColor: .blue))
        items.append(SettingsItemView(itemView: Text(appointment.design), imageName: "paintbrush.pointed.fill", backgroundColor: .green))
        if let shop = appointment.shop {
            items.append(SettingsItemView(itemView: Text(shop.name), imageName: "house.fill", backgroundColor: .purple))
        }
        items.append(SettingsItemView(itemView: Text(appointment.bodyPart), imageName: "figure.mind.and.body", backgroundColor: .pink))
        return items
    }
}

#Preview {
    PhotoDetailView(image: .init())
}
