//
//  TJTabView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI

struct TJTabView: View {
    var body: some View {
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
        }
    }
}

struct TJTabView_Previews: PreviewProvider {
    static var previews: some View {
        TJTabView()
            .modifier(PreviewEnvironmentObjects())
    }
}
