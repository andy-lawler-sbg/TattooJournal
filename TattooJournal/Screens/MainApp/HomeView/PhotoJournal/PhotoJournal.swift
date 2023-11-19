//
//  PhotoJournal.swift
//  TattooJournal
//
//  Created by Andy Lawler on 17/11/2023.
//

import SwiftUI
import PhotosUI
import SwiftData

struct PhotoJournal: View {

    @EnvironmentObject private var themeHandler: AppThemeHandler
    @Environment(\.modelContext) private var context

    @State private var imageSelected: PhotosPickerItem? = nil
    @State private var journalExpanded = false

    @State private var imageTappedToScale: TattooImage? = nil
    @State private var imageTapped: TattooImage? = nil
    @State private var imageLongTapped: TattooImage? = nil

    @Query private var queriedImages: [TattooImage]

    var images: [TattooImage] {
        journalExpanded ? queriedImages : Array(queriedImages.prefix(4))
    }

    var shouldShowExpandButton: Bool {
        queriedImages.count > 4
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Label("Journal", systemImage: "photo.stack")
                    .font(.body)
                    .bold()
                    .foregroundStyle(themeHandler.appColor)
                Spacer()
                PhotosPicker(selection: $imageSelected,
                             matching: .images,
                             photoLibrary: .shared()) {
                    XMarkButton(icon: "plus")
                }.opacity(images.isEmpty ? 0.0 : 1.0)
            }
            .padding(.leading, 6)
            .padding(.bottom, 4)
            VStack {
                if images.isEmpty {
                    photosIsEmptyView
                } else {
                    hasPhotosView
                }
            }
            .task(id: imageSelected) {
                if let data = try? await imageSelected?.loadTransferable(type: Data.self) {
                    let image = TattooImage(image: data)
                    withAnimation {
                        context.insert(image)
                        imageSelected = nil
                    }
                }
            }
            .sheet(item: $imageTapped) {
                imageTapped = nil
            } content: { image in
                PhotoDetailView(image: image)
                    .presentationDragIndicator(.visible)
            }
            .sheet(item: $imageLongTapped) {
                imageLongTapped = nil
            } content: { image in
                PhotoDeleteModal(image: image)
                    .presentationDetents([.height(75)])
                    .presentationDragIndicator(.visible)
            }

        }
        .padding(.horizontal, 5)
    }

    private var hasPhotosView: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 7) {
                ForEach(images) { tattooImage in
                    if let uiImage = UIImage(data: tattooImage.image) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .fullScreenCover(item: $imageTappedToScale, onDismiss: {
                                imageTappedToScale = nil
                            }, content: { image in
                                PhotoFullScreenView(image: image)
                            })
                            .overlay(alignment: .bottomTrailing) {
                                if tattooImage.appointment != nil {
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
                                withAnimation {
                                    if tattooImage.appointment == nil {
                                        imageTappedToScale = tattooImage
                                    } else {
                                        imageTapped = tattooImage
                                    }
                                }
                            }
                            .onLongPressGesture {
                                withAnimation {
                                    imageLongTapped = tattooImage
                                }
                            }
                    }
                }
            }
            .padding(.horizontal, 7)

            if shouldShowExpandButton {
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
    }

    private var emptyImageView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .foregroundStyle(Color(.cellBackground))
                .shadow(color: .black.opacity(0.025), radius: 2, x: 5, y: 5)
            Image(systemName: "photo.on.rectangle")
                .resizable()
                .scaledToFit()
                .padding(50)
                .foregroundStyle(themeHandler.appColor)
        }.aspectRatio(1, contentMode: .fit)
    }

    private var photosIsEmptyView: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 7) {
                emptyImageView
                emptyImageView
            }
            .padding(.horizontal, 7)

            Text("You have no images uploaded. Tap here to add some pictures of your previous tattoos.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .padding(.vertical)

            PhotosPicker(selection: $imageSelected,
                         matching: .images,
                         photoLibrary: .shared()) {
                Label("Add Images", systemImage: "square.and.arrow.up.on.square")
                    .bold()
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .foregroundColor(themeHandler.appColor)
                    .padding()
                    .frame(width: 200)
                    .background(themeHandler.appColor.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: .black.opacity(0.05), radius: 5, y: 3)
            }
        }
    }
}

#Preview {
    PhotoJournal()
}
