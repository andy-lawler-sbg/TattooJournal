//
//  PersonalView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 04/08/2023.
//

import SwiftUI

struct PersonalView: View {
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("Statistics")
                } header: {
                    Text("Data")
                } footer: {
                    Text("This includes your date, artist, price and design.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }.navigationTitle("👤 Personal")
        }
    }
}

#Preview {
    PersonalView()
}
