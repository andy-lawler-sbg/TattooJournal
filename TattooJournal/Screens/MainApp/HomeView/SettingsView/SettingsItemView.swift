//
//  SettingsItemView.swift
//  TattooJournal
//
//  Created by Andrew Lawler on 22/10/2023.
//

import SwiftUI

struct SettingsItemView<Content: View>: View {
    
    let id = UUID()
    var itemView: Content
    var imageName: String
    var imageColor: Color = .white
    var backgroundColor: Color

    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(backgroundColor)
                Image(systemName: imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(imageColor)
                    .padding(8)
            }
            .frame(width: 35, height: 35)
            itemView
        }.padding(.vertical, 2)
    }
}

#Preview {
    @State var selectedColor: Color = .red
    return Form {
        Section {
            SettingsItemView(
                itemView: ColorPicker("App Tint", selection: $selectedColor),
                imageName: "paintbrush.fill",
                backgroundColor: .red)
        }
    }
}
