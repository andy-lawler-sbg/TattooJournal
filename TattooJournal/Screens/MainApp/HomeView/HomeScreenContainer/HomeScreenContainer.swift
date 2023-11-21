//
//  HomeScreenContainer.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/11/2023.
//

import SwiftUI

final class SectionHeaderViewModel<Content: View> {
    let title: String
    let systemImage: String
    let button: Content
    
    init(title: String, systemImage: String, button: Content) {
        self.title = title
        self.systemImage = systemImage
        self.button = button
    }
}

struct SectionHeaderView<Content: View>: View {

    @EnvironmentObject private var themeHandler: AppThemeHandler
    let viewModel: SectionHeaderViewModel<Content>

    var body: some View {
        HStack {
            Label(viewModel.title, systemImage: viewModel.systemImage)
                .font(.body)
                .bold()
                .foregroundStyle(themeHandler.appColor)
            Spacer()
            viewModel.button
        }
        .padding(.leading, 6)
        .padding(.bottom, 4)
    }
}

final class HomeScreenContainerViewModel<HeaderContent: View, PageContent: View> {
    let sectionHeaderView: SectionHeaderView<HeaderContent>
    let pageContent: PageContent

    init(title: String,
         systemImage: String,
         button: HeaderContent,
         pageContent: PageContent
    ) {
        self.sectionHeaderView = SectionHeaderView(viewModel: .init(title: title, 
                                                                    systemImage: systemImage,
                                                                    button: button))
        self.pageContent = pageContent
    }
}

struct HomeScreenContainer<HeaderContent: View, PageContent: View>: View {

    let viewModel: HomeScreenContainerViewModel<HeaderContent, PageContent>

    var body: some View {
        VStack {
            viewModel.sectionHeaderView
            viewModel.pageContent
        }.padding(.horizontal, 5)
    }
}

#Preview {
    HomeScreenContainer(viewModel: .init(title: "Testing",
                                         systemImage: "plus",
                                         button: Circle(),
                                         pageContent: Text("Hello World")))
}
