//
//  NavBarItem.swift
//  TattooJournal
//
//  Created by Andrew Lawler on 22/10/2023.
//

import SwiftUI

struct NavBarItem: View {

    @State private var symbolAnimationValue = 10

    var imageName: String

    var body: some View {
        ZStack {
            Circle()
                .frame(width: 40, height: 40)
                .foregroundStyle(Color(.cellBackground))
                .shadow(color: .black.opacity(0.1), radius: 5)
            Image(systemName: imageName)
                .imageScale(.medium)
                .frame(width: 60, height: 60)
                .foregroundColor(.secondary)
                .bold()
                .symbolEffect(.pulse, value: symbolAnimationValue)
        }
    }
}

#Preview("Nav Bar Button") {
    ZStack {
        Color.gray.opacity(0.1)
        NavBarItem(imageName: "gear")
    }
}
