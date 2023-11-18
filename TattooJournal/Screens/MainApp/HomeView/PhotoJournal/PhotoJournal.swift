//
//  PhotoJournal.swift
//  TattooJournal
//
//  Created by Andy Lawler on 17/11/2023.
//

import SwiftUI
import PhotosUI
import SwiftData

struct JournalImage: Identifiable {
    let id = UUID()

    let image: Image
    let design: String
    let date: Date
    let price: String
    let bodyPart: TattooLocation.RawValue
    let artistName: String
    let shopName: String

    let hasInformation: Bool
}

enum MockImages {
    static let images: [JournalImage] = [
        .init(image: .init(.tattoo),
              design: "American Traditional Eagle",
              date: .now,
              price: "250",
              bodyPart: TattooLocation.arms.rawValue,
              artistName: "John Crompton",
              shopName: "Heart Of Ink Tattoo",
              hasInformation: true)
    ]
}

struct PhotoJournal: View {

    @EnvironmentObject private var themeHandler: AppThemeHandler

    @State private var imageSelected: PhotosPickerItem? = nil
    @State private var journalExpanded = false
    @State private var imageTapped: JournalImage? = nil

    var images: [JournalImage] {
        journalExpanded ? MockImages.images : Array(MockImages.images.prefix(4))
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Journal")
                    .font(.body)
                    .bold()
                Spacer()
                PhotosPicker(selection: $imageSelected,
                             matching: .images,
                             photoLibrary: .shared()) {
                    if !images.isEmpty {
                        XMarkButton(icon: "plus")
                    }
                }
            }
            .padding(.leading, 6)
            .padding(.bottom, 4)
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 7) {
                    ForEach(images) { journalImage in
                        journalImage.image
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .overlay(alignment: .bottomTrailing) {
                                if journalImage.hasInformation {
                                    ZStack {
                                        Circle()
                                            .frame(width: 30, height: 30)
                                            .foregroundStyle(Color(.cellBackground))
                                        Image(systemName: "hand.tap.fill")
                                            .imageScale(.small)
                                            .frame(width: 44, height: 44)
                                            .foregroundStyle(themeHandler.appColor)
                                    }
                                }
                            }
                            .onTapGesture {
                                if journalImage.hasInformation {
                                    imageTapped = journalImage
                                }
                            }
                    }
                }
                .padding(.horizontal, 7)
                if images.isEmpty {
                    Text("You have no images uploaded. Add some pictures of your previous tattoos.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                    PhotosPicker(selection: $imageSelected,
                                 matching: .images,
                                 photoLibrary: .shared()) {
                        Text("Add Images")
                            .bold()
                            .multilineTextAlignment(.center)
                            .font(.caption)
                            .foregroundColor(themeHandler.appColor)
                            .padding(13)
                            .padding(.horizontal, 20)
                            .background(themeHandler.appColor.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(color: .black.opacity(0.05), radius: 5, y: 3)
                    }
                } else {
                    Button {
                        withAnimation(.easeOut) {
                            journalExpanded.toggle()
                        }
                    } label: {
                        HStack {
                            Label(journalExpanded ? "Close" : "Expand", systemImage: journalExpanded ? "arrowshape.up.circle" : "arrowshape.down.circle")
                                .bold()
                                .lineLimit(1)
                                .font(.caption)
                                .foregroundColor(themeHandler.appColor)
                        }
                        .padding(13)
                        .padding(.horizontal, 20)
                        .background(themeHandler.appColor.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: .black.opacity(0.05), radius: 5, y: 3)
                    }
                    .padding(.top, 5)
                }
            }
            .sheet(item: $imageTapped) {
                imageTapped = nil
            } content: { image in
                NavigationStack {
                    VStack(alignment: .leading) {
                        image.image
                            .resizable()
                            .scaledToFit()
                        ForEach(pageContent(for: image), id: \.id) { page in
                            page
                        }
                        Spacer()
                    }
                    .navigationTitle("Image Details")
                    .padding(.horizontal)
                }
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
            }

        }
        .padding(.horizontal, 5)
    }

    @Query private var queriedUserPreferences: [UserPreferences]
    private var userPreferences: UserPreferences {
        queriedUserPreferences.first!
    }

    func pageContent(for image: JournalImage) -> [SettingsItemView<Text>] {
        var items: [SettingsItemView<Text>] = []
        items.append(SettingsItemView(itemView: Text(image.date.formatted()), imageName: "calendar", backgroundColor: .red))
        items.append(SettingsItemView(itemView: Text(image.artistName), imageName: "person.fill", backgroundColor: .mint))
        items.append(SettingsItemView(itemView: Text(image.price), imageName: "\(userPreferences.currency.rawValue)sign", backgroundColor: .blue))
        items.append(SettingsItemView(itemView: Text(image.design), imageName: "paintbrush.pointed.fill", backgroundColor: .green))
        items.append(SettingsItemView(itemView: Text(image.shopName), imageName: "house.fill", backgroundColor: .purple))
        items.append(SettingsItemView(itemView: Text(image.bodyPart), imageName: "figure.mind.and.body", backgroundColor: .pink))
        return items
    }
}

#Preview {
    PhotoJournal()
}
