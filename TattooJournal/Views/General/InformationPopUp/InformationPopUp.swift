//
//  InformationPopUp.swift
//  TattooJournal
//
//  Created by Andy Lawler on 04/08/2023.
//

import SwiftUI

struct InformationPopUp: View {

    @State private var shouldShowDetailPopup = true
    let text: String

    var body: some View {
        if shouldShowDetailPopup {
            Text(text)
                .font(.caption)
                .foregroundStyle(Color.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.vertical, 25)
                .background(
                    LinearGradient(
                        colors: [Color.accentColor.opacity(0.80), Color.accentColor],
                        startPoint: .top,
                        endPoint: .bottom)
                )
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .shadow(color: .black.opacity(0.05), radius: 5, y: 3)
                .overlay(alignment: .topTrailing) {
                    Button {
                        shouldShowDetailPopup = false
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 7.5, height: 7.5)
                            .font(.callout).bold()
                            .foregroundStyle(Color.white)
                            .padding(10)
                    }
                }
                .padding(.horizontal, 5)
        }
    }
}
#Preview {
    InformationPopUp(text: "This is a test of the information pop up, this can contain some text and can be dismissed if needed.")
}
