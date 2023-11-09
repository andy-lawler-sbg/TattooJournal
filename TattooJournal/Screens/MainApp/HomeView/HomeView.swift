//
//  HomeView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI
import SwiftData
import PhotosUI

struct HomeView: View {

    @Binding var selectedPage: Int
    @Bindable var viewModel = HomeViewModel()
    
    @EnvironmentObject private var themeHandler: AppThemeHandler
    @EnvironmentObject private var appEventHandler: AppEventHandler

    @State var imageSelected: PhotosPickerItem? = nil

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
                PhotosPicker(selection: $imageSelected,
                             matching: .images,
                             photoLibrary: .shared()) {
                    Text("Add Image")
                        .bold()
                        .foregroundStyle(themeHandler.appColor)
                        .frame(width: 180, height: 40)
                        .background(themeHandler.appColor.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                Spacer()
            }
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
            .onAppear {
                viewModel.setup(appEventHandler: appEventHandler)
            }
        }
    }

    private var spendingChart: some View {
        AppointmentSpendingChart(viewModel: .init(appointments: queriedAppointments))
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
