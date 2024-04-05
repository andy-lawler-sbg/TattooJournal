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
    @State private var imageToShowAppointmentDetail: TattooImage? = nil
    @State private var imageToShowArtistSelection: TattooImage? = nil
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
                .sheet(item: $imageToShowAppointmentDetail) {
                    imageToShowAppointmentDetail = nil
                } content: { image in
                    PhotoDetailView(image: image)
                        .presentationDragIndicator(.visible)
                }
                .sheet(item: $imageToShowArtistSelection) {
                    imageToShowArtistSelection = nil
                } content: { image in
                    ArtistSelectionSheet(tattooImage: image)
                        .presentationDetents([.medium])
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
                                            .foregroundStyle(Color(.oppositeStyle))
                                    }.onTapGesture {
                                        imageToShowAppointmentDetail = tattooImage
                                    }
                                } else {
                                    ZStack {
                                        Circle()
                                            .frame(width: 30, height: 30)
                                            .foregroundStyle(Color(.cellBackground))
                                        Image(systemName: "paintbrush.pointed.fill")
                                            .imageScale(.small)
                                            .frame(width: 44, height: 44)
                                            .foregroundStyle(Color(.oppositeStyle))
                                    }.onTapGesture {
                                        imageToShowArtistSelection = tattooImage
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
                                        .foregroundStyle(themeHandler.appColor)
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
                            .onTapGesture {
                                withAnimation {
                                    imageTappedToScale = tattooImage
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
            .frame(maxWidth: .infinity)
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

struct ArtistSelectionSheet: View {

    @Environment(\.modelContext) private var context
    @EnvironmentObject private var themeHandler: AppThemeHandler
    @Query private var artists: [Artist]
    @State private var selectedArtist: Artist? = nil
    @State private var showArtistForm = false
    @Bindable var tattooImage: TattooImage

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.background)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                VStack {
                    if artists.isEmpty {
                        EmptyState(imageName: "paintbrush.pointed.fill",
                                   title: "No Artists",
                                   description: "You have no artists, you can add some above.")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        List {
                            ForEach(artists) { artist in
                                HStack {
                                    Text(artist.name)
                                    Spacer()
                                    Button {
                                        selectedArtist = artist
                                    } label: {
                                        ZStack {
                                            Circle()
                                                .foregroundStyle(selectedArtist == artist ? themeHandler.appColor : Color(.background))
                                                .shadow(color: .black.opacity(0.1), radius: 5)
                                            if selectedArtist == artist {
                                                Image(systemName: "checkmark")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .bold()
                                                    .frame(width: 15, height: 15)
                                                    .foregroundStyle(.white)
                                            }
                                        }
                                        .frame(width: 30, height: 30)
                                    }
                                }
                                .padding(.vertical, 10)
                            }
                        }
                    }
                }
                .onChange(of: selectedArtist) {
                    print(selectedArtist?.name ?? "")
                }
                .navigationTitle("Artist Selection")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .sheet(isPresented: $showArtistForm) {
            ArtistForm()
                .presentationDetents([.height(270), .medium])
                .presentationDragIndicator(.visible)
        }
        .overlay(
            Button {
                showArtistForm = true
            } label: {
                XMarkButton(icon: "plus")
            }, alignment: .topTrailing
        )
    }
}
