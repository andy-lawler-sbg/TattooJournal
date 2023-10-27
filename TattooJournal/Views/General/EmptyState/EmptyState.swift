//
//  EmptyState.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI

struct EmptyState: View {

    @EnvironmentObject private var themeHandler: AppThemeHandler

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
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .foregroundColor(themeHandler.appColor)
                .padding()
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
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
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 200, height: 40)
                            .foregroundStyle(themeHandler.appColor.opacity(0.2))
                        Text(buttonText)
                            .bold()
                            .foregroundStyle(themeHandler.appColor)
                    }
                })
            }
        }
        .background(.clear)
        .padding()
        .padding(.bottom, isShowingActions ? 60 : 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
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
