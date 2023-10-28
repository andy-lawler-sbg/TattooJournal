//
//  StarRatingView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 28/10/2023.
//

import SwiftUI

struct StarRatingView: View {

    @State private var starOneSelected = false
    @State private var starTwoSelected = false
    @State private var starThreeSelected = false
    @State private var starFourSelected = false
    @State private var starFiveSelected = false

    var body: some View {
        HStack(spacing: 10) {
            StarRatingButton(isStarred: $starOneSelected)
                .disabled(isDisabled(for: .one))
            StarRatingButton(isStarred: $starTwoSelected)
                .disabled(isDisabled(for: .two))
            StarRatingButton(isStarred: $starThreeSelected)
                .disabled(isDisabled(for: .three))
            StarRatingButton(isStarred: $starFourSelected)
                .disabled(isDisabled(for: .four))
            StarRatingButton(isStarred: $starFiveSelected)
                .disabled(isDisabled(for: .five))
        }
    }

    /// This needs cleaning up, need to work out a better way to do this.
    private func isDisabled(for rating: Ratings) -> Bool {
        switch rating {
        case .one:
            return !true
        case .two:
            return !starOneSelected
        case .three:
            return !starTwoSelected
        case .four:
            return !starThreeSelected
        case .five:
            return !starFourSelected
        }
    }
}

private extension StarRatingView {
    enum Ratings {
        case one, two, three, four, five
    }
}

#Preview {
    StarRatingView()
}
