//
//  ShopFormView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 31/10/2023.
//

import SwiftUI

struct ShopFormView: View {

    @Bindable var shop: Shop
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Shop Name", text: $shop.name)
                        .autocorrectionDisabled()
                } header: {
                    Text("Shop Details")
                }

                Section {
                    Button {
                        dismiss()
                    } label: {
                        Text("Update")
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                    }
                }
                .navigationTitle("Update Shop")
            }
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
