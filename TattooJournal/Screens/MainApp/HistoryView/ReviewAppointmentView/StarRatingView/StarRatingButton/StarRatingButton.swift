//
//  StarRatingButton.swift
//  TattooJournal
//
//  Created by Andy Lawler on 28/10/2023.
//

import SwiftUI

struct StarRatingButton: View {

    @Binding var isStarred: Bool

    var body: some View {
        Image(systemName: isStarred ? Constants.starEnabled : Constants.starDisabled)
            .resizable()
            .scaledToFit()
            .frame(width: 30, height: 30)
            .foregroundStyle(.yellow)
            .onTapGesture {
                isStarred.toggle()
            }
    }
}

private extension StarRatingButton {
    enum Constants {
        static let starDisabled = "star"
        static let starEnabled = "star.fill"
    }
}

#Preview {
    StarRatingButton(isStarred: .constant(false))
}
