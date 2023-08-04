//
//  TJTabView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI

struct TJTabView: View {

    @EnvironmentObject var userPreferences: UserPreferences

    var body: some View {
        NavigationStack {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                AppointmentsView()
                    .tabItem {
                        Label("Appointments", systemImage: "book")
                    }
                PastTattoosView()
                    .tabItem {
                        Label("Past Tattoos", systemImage: "pencil.line")
                    }
                PersonalView()
                    .tabItem {
                        Label("Personal", systemImage: "person.fill")
                    }
            }
            .navigationBarBackButtonHidden()
            .tint(userPreferences.appColor)
        }
    }
}

#Preview {
    TJTabView()
        .modifier(PreviewEnvironmentObjects())
}
