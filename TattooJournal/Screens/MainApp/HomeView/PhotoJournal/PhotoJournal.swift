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

    var body: some View {
        photoGrid
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

    private var photoGrid: some View {
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
                if images.isEmpty {
                    imageUploadView
                    imageUploadView
                } else if images.count == 1 {
                    imageUploadView
                }
            }.padding(.horizontal, 7)

            if images.count < 2 {
                emptyTextView
            }

            if images.count > 4 {
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

    var emptyTextView: some View {
        emptyText
            .multilineTextAlignment(.center)
            .font(.caption)
            .foregroundColor(themeHandler.appColor)
            .padding()
            .padding(.horizontal)
            .background(themeHandler.appColor.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding()
    }

    var emptyText: some View {
        boldText + regularText
    }

    var regularText: Text {
        Text(images.isEmpty ?
            ", Tap above to add some pictures of your previous tattoos." :
            ", maybe upload some more?"
        )
    }

    var boldText: Text {
        Text(images.isEmpty ?
            "You have no images uploaded" :
            "You have one image uploaded"
        ).bold()
    }

    private var imageUploadView: some View {
        PhotosPicker(selection: $imageSelected,
                     matching: .images,
                     photoLibrary: .shared()) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color(.cellBackground))
                    .shadow(color: themeHandler.appColor,
                            radius: 0,
                            x: 0,
                            y: 2)
                VStack(spacing: 20) {
                    Image(systemName: "square.and.arrow.up.on.square")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(themeHandler.appColor)
                    Text("Add Image")
                        .bold()
                        .multilineTextAlignment(.center)
                        .font(.caption)
                        .foregroundColor(themeHandler.appColor)
                }
                .padding(50)
            }
            .aspectRatio(1, contentMode: .fit)
        }
    }
}

extension PhotoJournal {
    var headerViewButton: some View {
        PhotosPicker(selection: $imageSelected,
                     matching: .images,
                     photoLibrary: .shared()) {
            XMarkButton(icon: "plus")
        }
    }
}

#Preview {
    PhotoJournal()
}
