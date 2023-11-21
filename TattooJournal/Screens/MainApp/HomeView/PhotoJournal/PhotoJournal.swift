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
    @State private var imageDeleteAlert: Bool = false

    @Query private var queriedImages: [TattooImage]

    private var images: [TattooImage] {
        journalExpanded ? queriedImages : Array(queriedImages.prefix(4))
    }

    var headerViewButton: some View {
        PhotosPicker(selection: $imageSelected,
                     matching: .images,
                     photoLibrary: .shared()) {
            XMarkButton(icon: "plus")
        }
    }

    var body: some View {
        VStack {
            SectionHeaderView(viewModel: .init(title: "Journal", systemImage: "photo.stack", button: headerViewButton))
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
        }.padding(.horizontal, 5)
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
                                    .onTapGesture {
                                        withAnimation {
                                            if tattooImage.appointment == nil {
                                                imageTappedToScale = tattooImage
                                            } else {
                                                imageTapped = tattooImage
                                            }
                                        }
                                    }
                                }
                            }
                            .overlay(alignment: .topTrailing) {
                                ZStack {
                                    Circle()
                                        .frame(width: 30, height: 30)
                                        .foregroundStyle(Color(.cellBackground))
                                    Image(systemName: "xmark.bin.fill")
                                        .imageScale(.small)
                                        .frame(width: 44, height: 44)
                                        .foregroundStyle(.white)
                                }
                                .onTapGesture {
                                    withAnimation {
                                        imageDeleteAlert = true
                                    }
                                }
                                .alert("Are you sure?", isPresented: $imageDeleteAlert, actions: {
                                    Button {
                                        imageDeleteAlert = false
                                    } label: {
                                        Text("Cancel")
                                    }.tint(.red)
                                    Button {
                                        imageDeleteAlert = false
                                        context.delete(tattooImage)
                                    } label: {
                                        Text("Delete")
                                            .bold()
                                    }.tint(themeHandler.appColor)
                                }, message: {
                                    Text("Are you sure you want to delete this image?")
                                })
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

            if queriedImages.count < 2 {
                emptyTextView
            }

            if queriedImages.count > 4 {
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

#Preview {
    PhotoJournal()
}
