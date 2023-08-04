//
//  VisitedShops.swift
//  TattooJournal
//
//  Created by Andy Lawler on 28/04/2023.
//

import SwiftUI

struct VisitedShops: View {

    @Binding var shouldShowVisitedShops: Bool

    var body: some View {
        NavigationStack {
            Text("TBC ")
                .navigationTitle("🌍 Visited Shops")
        }
        .overlay(Button {
            shouldShowVisitedShops = false
        } label: {
            XMarkButton()
        }, alignment: .topTrailing)
    }
}

#Preview {
    VisitedShops(shouldShowVisitedShops: .constant(true))
        .modifier(PreviewEnvironmentObjects())
}
