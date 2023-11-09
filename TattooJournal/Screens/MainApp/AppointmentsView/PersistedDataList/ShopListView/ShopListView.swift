//
//  ShopListView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 31/10/2023.
//

import SwiftUI
import SwiftData

struct ShopListView: View {

    @State private var selectedMapShop: Shop?
    @State private var selectedEditShop: Shop?

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Query private var shops: [Shop]

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(shops) { shop in
                        HStack(spacing: 10) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(Color.accentColor)
                                Image(systemName: "house.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundStyle(.white)
                                    .padding(8)
                            }
                            .frame(width: 35, height: 35)
                            VStack(spacing: 0) {
                                Text(shop.name)
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(uiColor: UIColor.secondarySystemGroupedBackground))
                        .padding(.vertical, 2)
                        .swipeActions {
                            Button {
                                withAnimation {
                                    context.delete(shop)
                                    if shops.isEmpty {
                                        dismiss()
                                    }
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                                    .symbolVariant(.fill)
                            }

                            Button {
                                withAnimation {
                                    selectedEditShop = shop
                                }
                            } label: {
                                Label("Edit", systemImage: "pencil.and.list.clipboard")
                                    .symbolVariant(.fill)
                            } .tint(.yellow)
                        }
                        .onTapGesture {
                            selectedMapShop = shop
                        }
                    }
                } header: {
                    Text("Shops")
                } footer: {
                    Text("These are the shops you've been to before. Tap on them to see where they are 📍.")
                }
                .sheet(item: $selectedEditShop) {
                    withAnimation {
                        selectedEditShop = nil
                    }
                } content: { shop in
                    ShopFormView(shop: shop)
                }
                .sheet(item: $selectedMapShop) {
                    withAnimation {
                        selectedMapShop = nil
                    }
                } content: { shop in
                    EditShopMapView(shop: shop)
                        .presentationDetents([.height(550), .large])
                }
            }
            .navigationTitle("Shops")
        }
    }
}
