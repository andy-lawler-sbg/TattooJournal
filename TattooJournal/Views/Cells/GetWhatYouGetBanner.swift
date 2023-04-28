//
//  GetWhatYouGetBanner.swift
//  TattooJournal
//
//  Created by Andy Lawler on 27/04/2023.
//

import SwiftUI

struct GetWhatYouGetBanner: View {
    var body: some View {
        VStack {
            VStack(alignment: .center, spacing: 10) {
                Text(Constants.title)
                    .font(.headline)
                    .fontWeight(.bold)
                Text(Constants.description)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .modifier(CellOutline())
    }
}

private extension GetWhatYouGetBanner {
    enum Constants {
        static let title = "Get What You Get"
        static let description = "Get a random design using this new feature."
    }
}

struct GetWhatYouGetBanner_Previews: PreviewProvider {
    static var previews: some View {
        GetWhatYouGetBanner()
    }
}
