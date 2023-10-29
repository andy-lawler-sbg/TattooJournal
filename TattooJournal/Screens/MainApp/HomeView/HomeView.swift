//
//  HomeView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI
import SwiftData

@Observable
final class ShopListViewModel {
    let shops: [Shop]

    init(shops: [Shop]) {
        self.shops = shops
    }
}

struct ShopListView: View {
    let viewModel: ShopListViewModel
    @State var selectedArtist: Artist?

    var body: some View {
        VStack {
            ForEach(viewModel.shops) { shop in
                Text(shop.name)
                    .font(.headline).bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 5)
                ForEach(shop.artists) { artist in
                    Text("\u{2022} " + artist.name)
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ForEach(artist.appointments) { appointment in
                        Text("\u{2022} " + appointment.date.formatted() + " - " + appointment.design)
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }.padding(.leading, 15)
                }.padding(.bottom, 5)
            }
        }.padding()
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

    @Query private var artists: [Artist]
    @Query private var shops: [Shop]

    var body: some View {
        NavigationStack {
            VStack {
                ShopListView(viewModel: .init(shops: shops))
                List {
                    ForEach(shops) { shop in
                        Text(shop.name)
                            .font(.body)
                            .foregroundStyle(.primary)
                            .listRowSeparator(.hidden)
                            .swipeActions(allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    context.delete(shop)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                        .symbolVariant(.fill)
                                }
                            }
                    }
                }
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

    private var artistsCollectionView: some View {
        ArtistsCollectionView(viewModel: .init(artists: artists))
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
