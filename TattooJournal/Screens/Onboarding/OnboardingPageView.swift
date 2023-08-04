//
//  OnboardingPageView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 04/08/2023.
//

import SwiftUI

struct OnboardingPageView: View {

    let page: OnboardingPage
    @Binding var enterApp: Bool

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: page.image)
                .resizable()
                .scaledToFit()
                .frame(width: 175, height: 175)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white)
            Text(page.title)
                .font(.title).bold()
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
            Text(page.description)
                .font(.callout)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 25)
            Spacer()
                .frame(minHeight: 20, maxHeight: 50)
            if page.showEnterPage {
                Button {
                    enterApp = true
                } label: {
                    Text("Enter")
                        .foregroundStyle(Color.accentColor)
                        .font(.callout).bold()
                        .padding(.vertical, 13)
                        .frame(width: 220)
                        .background(.white)
                        .clipShape(.buttonBorder)
                }
            }
        }
    }
}

#Preview {
    OnboardingView {
        OnboardingPageView(page: .init(id: 1,
                                       title: "Test Onboarding",
                                       image: "book.fill",
                                       description: "This is just a test onboarding page.",
                                       showEnterPage: true),
                           enterApp: .constant(false))
    }
}
