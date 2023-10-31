//
//  ArtistAndShopList.swift
//  TattooJournal
//
//  Created by Andy Lawler on 31/10/2023.
//

import SwiftUI
import SwiftData

struct ArtistAndShopList: View {

    @Query private var artists: [Artist]
    @Query private var shops: [Shop]

    var body: some View {
        NavigationStack {
            VStack {
                Text("View all of the artists and shops you have used in past appointments.")
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                    .padding(.vertical, 7)
                List {
                    if !artists.isEmpty {
                        NavigationLink {
                            artistListView
                        } label: {
                            HStack(spacing: 10) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(Color.accentColor)
                                    Image(systemName: Constants.artistIcon)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundStyle(.white)
                                        .padding(8)
                                }
                                .frame(width: 35, height: 35)
                                Text(Constants.artistText)
                                    .font(.headline)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            }
                            .padding(.vertical, 2)
                        }
                    }

                    if !shops.isEmpty {
                        NavigationLink {
                            shopListView
                        } label: {
                            HStack(spacing: 10) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(Color.accentColor)
                                    Image(systemName: Constants.shopIcon)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundStyle(.white)
                                        .padding(8)
                                }
                                .frame(width: 35, height: 35)
                                Text(Constants.shopText)
                                    .font(.headline)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            }
                            .padding(.vertical, 2)
                        }
                    }
                }
            }
            .background(Color(.background))
            .navigationTitle("Saved Data")
        }
    }

    private var shopListView: some View {
        ShopListView()
    }

    private var artistListView: some View {
        ArtistListView()
    }
}

private extension ArtistAndShopList {
    enum Constants {
        static let artistIcon = "paintbrush.pointed.fill"
        static let artistText = "Artists"

        static let shopIcon = "house.fill"
        static let shopText = "Shops"
    }
}
