//
//  GetWhatYouGet.swift
//  TattooJournal
//
//  Created by Andy Lawler on 27/04/2023.
//

import SwiftUI

struct GetWhatYouGetItem: Identifiable {
    let id = UUID()
    let title: String
    var isSelected: Bool
}

struct GetWhatYouGetItemView: View {
    let item: GetWhatYouGetItem

    var body: some View {
        VStack(spacing: 10) {
            Text(item.title)
        }
        .padding()
        .background(Color.white)
        .border(item.isSelected ? Color.yellow : Color.black)
        .shadow(radius: 2)
    }
}

struct GetWhatYouGet: View {

    @Binding var isShowingGetWhatYouGet: Bool

    @State var shouldSpin = true
    @State var selectedItemIndex: Int? = nil

    @State var items: [GetWhatYouGetItem] = [
        GetWhatYouGetItem(title: "Snake", isSelected: false),
        GetWhatYouGetItem(title: "Tiger", isSelected: false),
        GetWhatYouGetItem(title: "Swallow", isSelected: false),
        GetWhatYouGetItem(title: "Ship", isSelected: false)
    ]

    var body: some View {
        NavigationStack {
            VStack {
                Text(Constants.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(items) { item in
                            GetWhatYouGetItemView(item: item)
                                .padding(.horizontal, 10)
                        }
                    }
                    .padding()
                }
                Button {
                    if let selectedItemIndex {
                        items[selectedItemIndex].isSelected = false
                    }
                    let rand = Int.random(in: 0..<items.count)
                    selectedItemIndex = rand
                    items[selectedItemIndex!].isSelected = true
                } label: {
                    Text("Spin")
                }
                .buttonStyle(.bordered)
                .tint(.accentColor)
                .controlSize(.large)
                Spacer()
            }.navigationTitle(Constants.title)
        }
        .overlay(Button {
            isShowingGetWhatYouGet = false
        } label: {
            XMarkButton()
        }, alignment: .topTrailing)
    }
}

private extension GetWhatYouGet {
    enum Constants {
        static let title = "🔮 Get What You Get"
        static let description = "Get a random traditional tattoo theme using our get what you get machine."
    }
}

struct GetWhatYouGet_Previews: PreviewProvider {
    static var previews: some View {
        GetWhatYouGet(isShowingGetWhatYouGet: .constant(true))
    }
}
