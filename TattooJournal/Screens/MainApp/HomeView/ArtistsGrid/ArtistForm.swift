//
//  ArtistForm.swift
//  TattooJournal
//
//  Created by Andy Lawler on 01/12/2023.
//

import SwiftUI
import SwiftData

struct ArtistForm: View {

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var artistName: String = ""
    @State private var artistInstagramHandle: String = ""

    @FocusState private var focusedTextField: FormTextField?
    enum FormTextField {
        case artistName, artistInstagramHandle
    }

    var canUpload: Bool {
        !artistName.isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Artist Name", text: $artistName)
                        .focused($focusedTextField, equals: .artistName)
                        .onSubmit { focusedTextField = .artistInstagramHandle }
                        .submitLabel(.next)
                        .autocorrectionDisabled()
                    TextField("Instagram @", text: $artistInstagramHandle)
                        .focused($focusedTextField, equals: .artistInstagramHandle)
                        .onSubmit { focusedTextField = nil }
                        .submitLabel(.next)
                        .autocorrectionDisabled()
                        .overlay(alignment: .trailing) {
                            Text("Optional")
                                .font(.caption)
                                .italic()
                                .foregroundStyle(.tertiary)
                        }
                } header: {
                    Text("Artist Details")
                }
                if canUpload {
                    Section {
                        Button {
                            let artist = Artist(name: artistName,
                                                instagramHandle: artistInstagramHandle.isEmpty ? nil : artistInstagramHandle)
                            context.insert(artist)
                            dismiss()
                        } label: {
                            Text("Create")
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
            }
            .navigationTitle("Add Artist")
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
    ArtistForm()
}
