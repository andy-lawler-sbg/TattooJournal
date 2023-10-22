//
//  Modifiers.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI

struct PreviewEnvironmentObjects: ViewModifier {
    func body(content: Content) -> some View {
        content
            .environmentObject(UserPreferences())
    }
}

struct CellOutline: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    HStack {
        Spacer()
    }
    .frame(height: 50)
    .modifier(CellOutline())
    .padding(.horizontal)
}
