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
    var shadowOpacity: Double = 0.05
    var shadowRadius: CGFloat = 5

    var body: some View {
        ZStack {
            Circle()
                .frame(width: circleSize, height: circleSize)
                .foregroundStyle(Color(.cellBackground))
                .shadow(color: .black.opacity(shadowOpacity), radius: shadowRadius)
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: imageSize, height: imageSize)
                .foregroundColor(themeHandler.appColor)
                .bold()
                .symbolEffect(.pulse, value: symbolAnimationValue)
        }
        .onAppear {
            withAnimation {
                symbolAnimationValue = 0
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    symbolAnimationValue = 2
                }
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
