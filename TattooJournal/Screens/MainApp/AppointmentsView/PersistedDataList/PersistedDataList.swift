//
//  PersistedDataList.swift
//  TattooJournal
//
//  Created by Andy Lawler on 31/10/2023.
//

import SwiftUI
import SwiftData

struct PersistedDataList: View {
    
    @EnvironmentObject private var themeHandler: AppThemeHandler
    @Environment(\.dismiss) private var dismiss

    @Query private var artists: [Artist]
    @Query private var shops: [Shop]

    private var descriptionText: some View {
        Text("View all of the artists and shops you have saved within the app.")
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
            .font(.callout)
            .foregroundStyle(.secondary)
            .padding(.horizontal, 20)
            .padding(.top)
            .padding(.bottom, 7)
    }

    var body: some View {
        NavigationStack {
            VStack {
                descriptionText
                List {
                    NavigationLink {
                        artistListView
                    } label: {
                        HStack(spacing: 10) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(Color.pink)
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

                    NavigationLink {
                        shopListView
                    } label: {
                        HStack(spacing: 10) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(Color.blue)
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
            .background(Color(.background))
            .navigationTitle("Saved Data")
        }
        .overlay(
            Button {
                dismiss()
            } label: {
               XMarkButton()
            }, alignment: .topTrailing
        )
    }

    private var shopListView: some View {
        ShopListView()
    }

    private var artistListView: some View {
        ArtistListView()
    }
}

private extension PersistedDataList {
    enum Constants {
        static let artistIcon = "paintbrush.pointed.fill"
        static let artistText = "Artists"

        static let shopIcon = "house.fill"
        static let shopText = "Shops"
    }
}
