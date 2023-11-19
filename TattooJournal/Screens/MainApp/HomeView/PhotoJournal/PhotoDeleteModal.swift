//
//  PhotoDeleteModal.swift
//  TattooJournal
//
//  Created by Andy Lawler on 18/11/2023.
//

import SwiftUI
import SwiftData

struct PhotoDeleteModal: View {
    
    @EnvironmentObject private var themeHandler: AppThemeHandler
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    let image: TattooImage

    var body: some View {
        NavigationStack {
            List {
                Button {
                    withAnimation {
                        context.delete(image)
                        dismiss()
                    }
                } label: {
                    Text("Delete")
                        .font(.body)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .foregroundStyle(themeHandler.appColor)
                }
            }
        }
    }
}

#Preview {
    PhotoDeleteModal(image: .init())
}
