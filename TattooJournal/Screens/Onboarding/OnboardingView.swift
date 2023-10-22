//
//  OnboardingView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 04/08/2023.
//

import SwiftUI

struct OnboardingView: View {

    @State var selectedPage = 0
    @Binding var isShowingOnboarding: Bool

    var body: some View {
        TabView(selection: $selectedPage) {
            ForEach(OnboardingData.pages) { page in
                OnboardingPageView(page: page, isShowingOnboarding: $isShowingOnboarding)
            }
        }
        .overlay(alignment: .topTrailing) {
            if selectedPage != 3 {
                Button {
                    isShowingOnboarding = false
                } label: {
                    Text("Skip")
                        .font(.callout).bold()
                        .foregroundStyle(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color.accentColor.opacity(0.5))
                        .clipShape(.capsule)
                        .padding()
                }
                .onTapGesture(perform: Haptics.shared.successHaptic)
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .padding(.bottom)
        .background(
            LinearGradient(colors: [Color(.lighterAccent), Color.accentColor],
                           startPoint: .top,
                           endPoint: .bottom)
        )
    }
}

#Preview {
    OnboardingView(isShowingOnboarding: .constant(true))
}
