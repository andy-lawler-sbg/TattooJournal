//
//  EmptyState.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI
import TipKit

struct EmptyState: View {

    @EnvironmentObject var userPreferences: UserPreferences

    let imageName: String
    let title: String
    let description: String

    var body: some View {
        VStack(spacing: 5) {
            VStack {
                Image(systemName: imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                    .foregroundColor(userPreferences.appColor)
                    .padding()
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Text(description)
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


#Preview {
    EmptyState(imageName: "gear", title: "Sorry", description: "You have not set any settings.")
        .modifier(PreviewEnvironmentObjects())
}
