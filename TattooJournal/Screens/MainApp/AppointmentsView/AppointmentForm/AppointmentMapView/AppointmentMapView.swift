//
//  AppointmentMapView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI
import MapKit

struct AppointmentMapView: View {

    // MARK: - Observed Object

    @Bindable var formViewModel: AppointmentFormViewModel

    // MARK: - Binding

    @Binding var isShowingMapView: Bool

    // MARK: - State

    @State var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 55, longitude: -3),
                                              span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
    @State var locations: [Location] = []

    // MARK: - Properties & Functions

    private var hasNoLocation: Bool { locations.count == 0 }

    private func changeLocation() {
        removeCurrentlySetLocation()
        let location = Location(id: UUID(),
                                name: "Tattoo Shop",
                                description: "This is the location of the tattoo shop",
                                latitude: mapRegion.center.latitude,
                                longitude: mapRegion.center.longitude)
        formViewModel.appointment.shop.location = location
        locations.append(location)
    }

    private func removeCurrentlySetLocation() {
        formViewModel.appointment.shop.location = nil
        formViewModel.appointment.shop.title = ""
        locations = []
    }

    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    Text(Constants.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                    if !hasNoLocation {
                        TextField(Constants.textFieldPlaceholder, text: $formViewModel.appointment.shop.title)
                            .submitLabel(.done)
                            .frame(maxWidth: .infinity)
                            .frame(height: 30)
                            .multilineTextAlignment(.center)
                            .background(Color.primary.opacity(0.1))
                            .foregroundColor(.primary)
                            .cornerRadius(15)
                            .padding()
                    }
                }
                ZStack {
                    Map(coordinateRegion: $mapRegion, annotationItems: locations) { location in
                        MapMarker(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                    }
                    .edgesIgnoringSafeArea(.bottom)
                    Circle()
                        .fill(.blue)
                        .opacity(0.3)
                        .frame(width: 32, height: 32)
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            if hasNoLocation {
                                Button {
                                    changeLocation()
                                } label: {
                                    Image(systemName: Constants.Buttons.pin)
                                }
                                .modifier(AppointmentMapViewButtonStyling())
                            } else {
                                Button {
                                    removeCurrentlySetLocation()
                                } label: {
                                    Image(systemName: Constants.Buttons.slashPin)
                                }
                                .modifier(AppointmentMapViewButtonStyling())
                                Button {
                                    isShowingMapView = false
                                } label: {
                                    Image(systemName: Constants.Buttons.add)
                                }
                                .modifier(AppointmentMapViewButtonStyling())
                            }
                        }
                    }

                }
            }
            .navigationTitle(Constants.title)
            .toolbar {
                Button {
                    isShowingMapView = false
                } label: {
                    XMarkButton()
                }
            }
            .onAppear {
                if let location = formViewModel.appointment.shop.location {
                    self.locations.append(location)
                }
            }
        }
    }
}

private extension AppointmentMapView {
    enum Constants {
        static let title = "📍 Shop Location"
        static let description = "Please set the location of the shop you are visiting."
        static let textFieldPlaceholder = "Shop Name"

        enum Buttons {
            static let pin = "mappin"
            static let slashPin = "mappin.slash"
            static let add = "hand.thumbsup"
        }
    }
}

#Preview {
    AppointmentMapView(formViewModel: AppointmentFormViewModel(appointment: nil),
                       isShowingMapView: .constant(true))
}
