//
//  OnboardingView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 04/08/2023.
//

import SwiftUI

struct OnboardingView<Destination: View>: View {

    @State var selectedPage = 0
    @State var enterApp = false

    @ViewBuilder let destination: () -> Destination

    var body: some View {
        NavigationStack {
            TabView(selection: $selectedPage) {
                ForEach(OnboardingData.pages) { page in
                    OnboardingPageView(page: page, enterApp: $enterApp)
                }
            }
            .navigationDestination(isPresented: $enterApp) {
                destination()
            }
            .overlay(alignment: .topTrailing) {
                if selectedPage != 3 {
                    Button {
                        enterApp = true
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
}

#Preview {
    OnboardingView {
        TJTabView()
            .modifier(PreviewEnvironmentObjects())
    }
}
