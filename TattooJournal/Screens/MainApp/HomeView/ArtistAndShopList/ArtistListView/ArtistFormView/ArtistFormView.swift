//
//  ArtistFormView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 31/10/2023.
//

import SwiftUI

struct ArtistFormView: View {

    @Bindable var artist: Artist
    @Environment(\.dismiss) private var dismiss

    @State private var instagramHandle: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Artist Name", text: $artist.name)
                        .autocorrectionDisabled()
                    TextField("Artist Instagram Handle", text: $instagramHandle)
                        .autocorrectionDisabled()
                } header: {
                    Text("Artist Details")
                }

                Section {
                    Button {
                        artist.instagramHandle = instagramHandle
                        dismiss()
                    } label: {
                        Text("Update")
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                    }
                }
                .navigationTitle("Update Artist")
            }
        }
        .overlay(
            Button {
                dismiss()
            } label: {
                XMarkButton()
            }, alignment: .topTrailing
        )
        .onAppear {
            instagramHandle = artist.instagramHandle ?? ""
        }
    }
}
