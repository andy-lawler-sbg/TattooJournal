//
//  HomeView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI
import SwiftData

struct ArtistListView: View {
    @Environment(\.modelContext) private var context
    @Query private var artists: [Artist]

    var body: some View {
        List(artists) { artist in
            Text(artist.name)
                .font(.headline).bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 5)
                .swipeActions {
                    Button {
                        context.delete(artist)
                    } label: {
                        Text("Delete")
                    }

                }
        }
    }
}

struct ShopListView: View {

    @Environment(\.modelContext) private var context
    @Query private var shops: [Shop]

    var body: some View {
        List(shops) { shop in
            Text(shop.name)
                .font(.headline).bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 5)
                .swipeActions {
                    Button {
                        context.delete(shop)
                    } label: {
                        Text("Delete")
                    }

                }
        }
    }
}

struct HomeView: View {

    @Binding var selectedPage: Int
    @Bindable var viewModel = HomeViewModel()

    @EnvironmentObject private var themeHandler: AppThemeHandler
    @EnvironmentObject private var appEventHandler: AppEventHandler
    @Environment(\.modelContext) private var context

    @Query(
        sort: \Appointment.date,
        order: .forward
    ) private var queriedAppointments: [Appointment]

    private var upcomingAppointments: [Appointment] {
        let startDate: Date = Date()
        return queriedAppointments.filter({ $0.date >= startDate })
    }

    var body: some View {
        NavigationStack {
            VStack {
                ShopListView()
                ArtistListView()
            }
            .background(Color(.background))
            .navigationTitle(Constants.title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation {
                            viewModel.shouldShowSettingsScreen = true
                        }
                    } label: {
                        NavBarItem(imageName: Constants.ImageNames.settings)
                    }
                    .onTapGesture(perform: Haptics.shared.successHaptic)
                }
            }
            .sheet(isPresented: $viewModel.shouldShowSettingsScreen) {
                SettingsView()
            }
            .onAppear {
                viewModel.setup(appEventHandler: appEventHandler)
            }
        }
    }

    private var spendingChart: some View {
        AppointmentSpendingChart(viewModel: .init(appointments: queriedAppointments))
    }


    private var homeTiles: some View {
        VStack {
            if upcomingAppointments.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("You have no appointments")
                        .frame(maxWidth: .infinity)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.primary)
                    Text("You currently have no appointments set, you might want to add some?")
                        .frame(maxWidth: .infinity)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 5)
                    Button(action: {
                        selectedPage = 2
                        /// Our appointments view does not sink on the publisher until it shows for the first time. If a user doesn't open
                        /// the appointments page first and hits this button, we need this delay to ensure we are currently waiting for this call.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            appEventHandler.eventPublisher.send(.addAppointment)
                        }
                    }, label: {
                        Text("Add")
                            .font(.caption)
                            .bold()
                            .foregroundStyle(themeHandler.appColor)
                            .frame(width: 130, height: 20)
                    })
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.bordered)
                    .controlSize(.regular)
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: 200)
                .padding()
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding()
            }
            VStack(alignment: .leading, spacing: 10) {
                Text("Don't forget Settings ⚙️")
                    .frame(maxWidth: .infinity)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.primary)
                Text("You can customise everything about your experience within the app using the settings. ")
                    .frame(maxWidth: .infinity)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 5)
                Button(action: {
                    viewModel.shouldShowSettingsScreen = true
                }, label: {
                    Text("Go")
                        .font(.caption)
                        .bold()
                        .foregroundStyle(themeHandler.appColor)
                        .frame(width: 130, height: 20)
                })
                .frame(maxWidth: .infinity)
                .buttonStyle(.bordered)
                .controlSize(.regular)
            }
            .frame(maxWidth: .infinity)
            .frame(maxHeight: 200)
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding()
            Spacer()
        }
    }
}

extension HomeView {
    enum Constants {
        static let title = "Home"
        enum ImageNames {
            static let settings = "gear"
        }
    }
}

#Preview("Home Screen") {
    TabView {
        HomeView(selectedPage: .constant(1))
            .tabItem {
                Label("Home", systemImage: "house")
            }
            .environmentObject(AppThemeHandler())
    }
}
