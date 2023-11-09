//
//  VisitedShops.swift
//  TattooJournal
//
//  Created by Andy Lawler on 28/04/2023.
//

import SwiftUI
import SwiftData
import MapKit

struct VisitedShops: View {

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeHandler: AppThemeHandler

    @Query private var shops: [Shop]

    var body: some View {
        NavigationStack {
            Map {
                ForEach(shops) { shop in
                    Marker(shop.name,
                           systemImage: "house.fill",
                           coordinate: shop.location ?? .init())
                }
            }
            .navigationTitle("Visited Shops")
        }
        .overlay(
            Button {
                dismiss()
            } label: {
                XMarkButton()
            }, alignment: .topTrailing
        )
    }
}

#Preview {
    VisitedShops()
}
