//
//  XMarkButton.swift
//  TattooJournal
//
//  Created by Andy Lawler on 27/04/2023.
//

import SwiftUI

struct XMarkButton: View {

    var icon: String = Constants.xmark

    var body: some View {
        ZStack {
            Circle()
                .frame(width: 30, height: 30)
                .foregroundStyle(Color(.cellBackground))
            Image(systemName: icon)
                .imageScale(.small)
                .frame(width: 44, height: 44)
                .foregroundStyle(Color(.oppositeStyle))
        }.padding(1)
    }
}

private extension XMarkButton {
    enum Constants {
        static let xmark = "xmark"
    }
}

#Preview {
    XMarkButton()
}
