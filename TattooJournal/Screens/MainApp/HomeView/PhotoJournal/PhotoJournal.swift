//
//  PhotoJournal.swift
//  TattooJournal
//
//  Created by Andy Lawler on 17/11/2023.
//

import SwiftUI
import PhotosUI

struct JournalImage: Identifiable {
    let id = UUID()
    let image: Image
}

enum MockImages {
    static let images: [JournalImage] = [
        .init(image: .init(.tattoo)),
        .init(image: .init(.tattoo)),
        .init(image: .init(.tattoo)),
        .init(image: .init(.tattoo)),
        .init(image: .init(.tattoo)),
        .init(image: .init(.tattoo)),
        .init(image: .init(.tattoo)),
        .init(image: .init(.tattoo)),
        .init(image: .init(.tattoo)),
        .init(image: .init(.tattoo)),
        .init(image: .init(.tattoo)),
        .init(image: .init(.tattoo)),
    ]
}

struct PhotoJournal: View {

    @EnvironmentObject private var themeHandler: AppThemeHandler

    @State private var imageSelected: PhotosPickerItem? = nil
    @State private var journalExpanded = false

    var images: [JournalImage] {
        journalExpanded ? MockImages.images : Array(MockImages.images.prefix(4))
    }

    var shouldShowFade: Bool {
        !journalExpanded && images.count >= 4
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
            .padding(.horizontal, 6)
            .padding(.bottom, 4)
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 7) {
                    ForEach(images) { journalImage in
                        journalImage.image
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
                .padding(.horizontal, 7)
                .mask {
                    withAnimation {
                        LinearGradient(gradient: Gradient(stops: [
                            .init(color: .black, location: 0.25),
                            .init(color: .black, location: 0.50),
                            .init(color: shouldShowFade ? .clear : .black, location: 0.75),
                            .init(color: shouldShowFade ? .clear : .black, location: 1)
                        ]), startPoint: .top, endPoint: .bottom)
                    }
                }
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
                        Text(journalExpanded ? "Close" : "Expand")
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
                    .offset(y: shouldShowFade ? -100 : 0)
                    .padding(.top, 5)
                }
            }
        }
        .padding(.horizontal, 5)
    }
}

#Preview {
    PhotoJournal()
}
