//
//  Modifiers.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI

struct AppointmentMapViewButtonStyling: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.black.opacity(0.75))
            .foregroundColor(.white)
            .font(.title)
            .clipShape(Circle())
            .padding(.trailing)
    }
}

struct PreviewEnvironmentObjects: ViewModifier {
    func body(content: Content) -> some View {
        content
            .environmentObject(Appointments())
            .environmentObject(UserPreferences())
    }
}

struct CellOutline: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color(.systemBackground))
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(UIColor.lightGray).opacity(0.5), lineWidth: 1.5)
            )
    }
}
