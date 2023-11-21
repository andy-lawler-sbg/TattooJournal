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

    @Binding var rating: Int

    var body: some View {
        HStack(spacing: 10) {
            StarRatingButton(isStarred: $starOneSelected)
            StarRatingButton(isStarred: $starTwoSelected)
            StarRatingButton(isStarred: $starThreeSelected)
            StarRatingButton(isStarred: $starFourSelected)
            StarRatingButton(isStarred: $starFiveSelected)
        }
        .onAppear {
            configureStars(for: rating)
        }
        .onChange(of: starOneSelected) {
            if starOneSelected {
                rating = 1
                configureStars(for: rating)
            } else {
                rating = 0
                configureStars(for: rating)
            }
        }
        .onChange(of: starTwoSelected) {
            if starTwoSelected {
                rating = 2
                configureStars(for: rating)
            } else {
                rating = 0
                configureStars(for: rating)
            }
        }
        .onChange(of: starThreeSelected) {
            if starThreeSelected {
                rating = 3
                configureStars(for: rating)
            } else {
                rating = 0
                configureStars(for: rating)
            }
        }
        .onChange(of: starFourSelected) {
            if starFourSelected {
                rating = 4
                configureStars(for: rating)
            } else {
                rating = 0
                configureStars(for: rating)
            }
        }
        .onChange(of: starFiveSelected) {
            if starFiveSelected {
                rating = 5
                configureStars(for: rating)
            } else {
                rating = 0
                configureStars(for: rating)
            }
        }
    }

    private func configureStars(for rating: Int) {
        if rating == 0 {
            starOneSelected = false
            starTwoSelected = false
            starThreeSelected = false
            starFourSelected = false
            starFiveSelected = false
        }
        if rating >= 1 {
            starOneSelected = true
        }
        if rating >= 2 {
            starTwoSelected = true
        }
        if rating >= 3 {
            starThreeSelected = true
        }
        if rating >= 4 {
            starFourSelected = true
        }
        if rating == 5 {
            starFiveSelected = true
        }
    }
}

private extension StarRatingView {
    enum Ratings {
        case one, two, three, four, five
    }
}

#Preview {
    StarRatingView(rating: .constant(5))
}
