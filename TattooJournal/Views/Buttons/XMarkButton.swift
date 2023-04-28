//
//  XMarkButton.swift
//  TattooJournal
//
//  Created by Andy Lawler on 27/04/2023.
//

import SwiftUI

struct XMarkButton: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                .opacity(0.6)
            Image(systemName: Constants.systemName)
                .imageScale(.small)
                .frame(width: 44, height: 44)
                .foregroundColor(.black)
        }.padding(1)
    }
}

private extension XMarkButton {
    enum Constants {
        static let systemName = "xmark"
    }
}

struct XMarkButton_Previews: PreviewProvider {
    static var previews: some View {
        XMarkButton()
    }
}
