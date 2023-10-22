//
//  EmptyState.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI

struct EmptyState: View {

    @EnvironmentObject var userPreferences: UserPreferences

    let imageName: String
    let title: String
    let description: String

    var body: some View {
        ContentUnavailableView {
            VStack {
                Image(systemName: imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                    .foregroundColor(Color.accentColor)
                    .padding()
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
        } description: {
            Text(description)
        }
    }
}


#Preview {
    EmptyState(imageName: "list.clipboard",
               title: "Sorry",
               description: "You have not set any settings.")
        .environmentObject(UserPreferences())
}
