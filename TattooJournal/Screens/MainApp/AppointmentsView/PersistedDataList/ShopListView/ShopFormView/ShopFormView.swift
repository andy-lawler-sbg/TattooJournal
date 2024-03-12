//
//  ShopFormView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 31/10/2023.
//

import SwiftUI
import CoreLocation

struct ShopFormView: View {

    @State private var shopName: String = ""
    @State private var shopLocation: CLLocationCoordinate2D? = nil

    var body: some View {
        ShopMapView(shopName: $shopName,
                    shopLocation: $shopLocation)
    }
}
