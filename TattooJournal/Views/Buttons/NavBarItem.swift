//
//  NavBarItem.swift
//  TattooJournal
//
//  Created by Andrew Lawler on 22/10/2023.
//

import SwiftUI

struct NavBarItem: View {

    @EnvironmentObject private var themeHandler: AppThemeHandler
    @State private var symbolAnimationValue = 0

    var imageName: String
    var circleSize: CGFloat = 40
    var imageSize: CGFloat = 20

    var body: some View {
        ZStack {
            Circle()
                .frame(width: circleSize, height: circleSize)
                .foregroundStyle(Color(.cellBackground))
                .shadow(color: .black.opacity(0.05), radius: 5)
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: imageSize, height: imageSize)
                .foregroundColor(themeHandler.appColor)
                .bold()
                .symbolEffect(.pulse, value: symbolAnimationValue)
        }.onAppear {
            withAnimation {
                symbolAnimationValue = 10
            }
        }
    }
}

#Preview("Nav Bar Button") {
    ZStack {
        Color.gray.opacity(0.1)
        NavBarItem(imageName: "gear")
    }
}
