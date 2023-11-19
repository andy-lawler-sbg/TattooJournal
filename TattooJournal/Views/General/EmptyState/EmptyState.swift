//
//  EmptyState.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI

struct EmptyState: View {

    @EnvironmentObject private var themeHandler: AppThemeHandler

    @State private var symbolAnimationValue = 0

    private let imageName: String
    private let title: String
    private let description: String

    private let buttonText: String?
    private let action: (() -> Void)?

    private var isShowingActions: Bool {
        buttonText != nil && action != nil
    }

    init(imageName: String,
         title: String,
         description: String,
         buttonText: String? = nil,
         action: (() -> Void)? = nil
    ) {
        self.imageName = imageName
        self.title = title
        self.description = description
        self.buttonText = buttonText
        self.action = action
    }

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 140)
                .foregroundStyle(themeHandler.appColor)
                .padding()
                .symbolEffect(.bounce, value: symbolAnimationValue)
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
            Text(description)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.bottom)
            if let buttonText, let action {
                Button(action: {
                    action()
                }, label: {
                    Text(buttonText)
                        .bold()
                        .foregroundStyle(themeHandler.appColor)
                        .frame(width: 180, height: 30)
                })
                .buttonStyle(.bordered)
                .controlSize(.regular)
            }
        }
        .background(.clear)
        .padding()
        .padding(.bottom, isShowingActions ? 60 : 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .onAppear {
            symbolAnimationValue = 10
        }
    }
}


#Preview {
    EmptyState(imageName: "list.clipboard",
               title: "No Appointments",
               description: "You currently have no appointments. Please add some.", 
               buttonText: "Add Appointments",
               action: { print("Clicked") })
        .environmentObject(AppThemeHandler())
}
