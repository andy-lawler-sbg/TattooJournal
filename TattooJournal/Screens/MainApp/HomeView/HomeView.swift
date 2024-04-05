//
//  HomeView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI
import SwiftData
import TipKit
import MapKit

struct HomeView: View {

    @Binding var selectedPage: Int
    @Bindable var viewModel = HomeViewModel()
    
    @EnvironmentObject private var themeHandler: AppThemeHandler
    @EnvironmentObject private var appEventHandler: AppEventHandler

    @Query(
        sort: \Appointment.date,
        order: .forward
    ) private var queriedAppointments: [Appointment]

    private let photoJournal = PhotoJournal()
    private let artistGrid = ArtistsGrid()
    
    var emptyTextView: some View {
        Label("You have no upcoming appointments. Add some?", systemImage: "clipboard.fill")
            .font(.caption)
            .foregroundColor(themeHandler.appColor)
            .frame(maxWidth: .infinity)
            .padding()
            .padding(.horizontal)
            .background(themeHandler.appColor.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding()
    }
    
    private var appointmentListView: some View {
        VStack {
            if let appointment = queriedAppointments.first {
                NextAppointmentView(appointment: appointment)
            } else {
                emptyTextView
            }
        }
    }
    
    private let charts = Charts()

    private var artistGridButton: some View {
        Button {
            viewModel.shouldShowArtistForm = true
        } label: {
            XMarkButton(icon: "plus")
        }
    }

    private var tipView: some View {
        TipView(HomeTip(), arrowEdge: .bottom)
            .tipBackground(Color(.cellBackground))
            .padding(.horizontal)
            .padding(.top, 7.5)
            .padding(.bottom, -10)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    tipView
                    HomeScreenContainer(viewModel: .init(title: "Upcoming",
                                                         systemImage: "list.clipboard.fill",
                                                         button: EmptyView(),
                                                         pageContent: appointmentListView))
                    HomeScreenContainer(viewModel: .init(title: "Artists",
                                                         systemImage: "paintbrush.pointed.fill",
                                                         button: artistGridButton,
                                                         pageContent: artistGrid))
                    photoJournal
                }.padding(.top)
                Spacer()
            }
            .scrollIndicators(.hidden)
            .frame(maxWidth: .infinity)
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
            .sheet(isPresented: $viewModel.shouldShowArtistForm) {
                ArtistForm()
                    .presentationDetents([.height(270), .medium])
                    .presentationDragIndicator(.visible)
            }
            .onAppear {
                viewModel.setup(appEventHandler: appEventHandler)
            }
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
