//
//  PhotoFullScreenView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 18/11/2023.
//

import SwiftUI

struct PhotoFullScreenView: View {

    @EnvironmentObject private var themeHandler: AppThemeHandler
    @Environment(\.dismiss) private var dismiss

    let image: TattooImage

    var body: some View {
        VStack {
            if let uiImage = UIImage(data: image.image) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                Button {
                    withAnimation {
                        dismiss()
                    }
                } label: {
                    Text("Close")
                        .bold()
                        .multilineTextAlignment(.center)
                        .font(.body)
                        .foregroundColor(themeHandler.appColor)
                        .frame(width: 200, height: 50)
                        .background(themeHandler.appColor.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: .black.opacity(0.05), radius: 5, y: 3)
                }
                .padding(.top)
            }
        }
    }
}

#Preview {
    PhotoFullScreenView(image: .init())
}
