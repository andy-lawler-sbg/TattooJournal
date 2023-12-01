//
//  ShopMapView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 01/11/2023.
//

import SwiftUI
import MapKit

struct ShopMapView: View {

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeHandler: AppThemeHandler

    @State private var position = MapCameraPosition.automatic
    @State private var isSheetPresented: Bool = true

    @State private var searchResults = [SearchResult]()
    @State private var selectedLocation: SearchResult?

    @Binding var shopName: String
    @Binding var shopLocation: CLLocationCoordinate2D?

    var body: some View {
        NavigationStack {
            ZStack {
                Map(position: $position, selection: $selectedLocation) {
                    ForEach(searchResults) { result in
                        Marker(coordinate: result.location) {
                            Image(systemName: "house.fill")
                        }
                        .tag(result)
                    }
                }
                .mapStyle(.hybrid)
                .ignoresSafeArea()
                if !shopName.isEmpty {
                    VStack {
                        Spacer()
                        Button {
                            selectedLocation = nil
                            searchResults.removeAll()
                            self.shopName = ""
                        } label: {
                            HStack {
                                Text("\(shopName)")
                                    .font(.body)
                                    .foregroundStyle(.white)
                                Image(systemName: "xmark.circle")
                                    .font(.body)
                                    .foregroundStyle(.white)
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 15)
                            .background(themeHandler.appColor)
                            .clipShape(.capsule)
                        }
                    }
                }
            }
            .onChange(of: selectedLocation) {
                shopLocation = selectedLocation?.location
                isSheetPresented = selectedLocation == nil
            }
            .onChange(of: searchResults) {
                if let firstResult = searchResults.first, searchResults.count == 1 {
                    selectedLocation = firstResult
                }
            }
            .sheet(isPresented: $isSheetPresented) {
                SheetView(searchResults: $searchResults, shopName: $shopName)
            }
            .navigationTitle("Shop Search")
            .onAppear {
                isSheetPresented = shopName.isEmpty || shopLocation == nil
                if let shopLocation {
                    let location = SearchResult(location: shopLocation)
                    selectedLocation = location
                    searchResults.append(location)
                }
            }
        }
    }
}

struct SheetView: View {

    @State private var locationService = LocationService(completer: .init())
    @State private var search: String = ""

    @Binding var searchResults: [SearchResult]
    @Binding var shopName: String

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search for a shop", text: $search)
                    .autocorrectionDisabled()
                    .onSubmit {
                        Task {
                            searchResults = (try? await locationService.search(with: search)) ?? []
                        }
                    }
            }
            .modifier(TextFieldGrayBackgroundColor())

            Spacer()

            List {
                ForEach(locationService.completions) { completion in
                    Button(action: { didTapOnCompletion(completion) }) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(completion.title)
                                .font(.headline)
                                .fontDesign(.rounded)
                            Text(completion.subTitle)
                        }
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        .onChange(of: search) {
            locationService.update(queryFragment: search)
        }
        .padding()
        .interactiveDismissDisabled()
        .presentationDetents([.height(200), .large])
        .presentationBackground(.regularMaterial)
        .presentationBackgroundInteraction(.enabled(upThrough: .large))
    }

    private func didTapOnCompletion(_ completion: SearchCompletions) {
        Task {
            if let singleLocation = try? await locationService.search(with: "\(completion.title) \(completion.subTitle)").first {
                searchResults = [singleLocation]
                shopName = completion.title
            }
        }
    }
}

struct TextFieldGrayBackgroundColor: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(.gray.opacity(0.1))
            .cornerRadius(8)
            .foregroundColor(.primary)
    }
}

struct SearchCompletions: Identifiable {
    let id = UUID()
    let title: String
    let subTitle: String
    var url: URL?
}

struct SearchResult: Identifiable, Hashable {
    let id = UUID()
    let location: CLLocationCoordinate2D

    static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

@Observable
class LocationService: NSObject, MKLocalSearchCompleterDelegate {
    private let completer: MKLocalSearchCompleter

    var completions = [SearchCompletions]()

    init(completer: MKLocalSearchCompleter) {
        self.completer = completer
        super.init()
        self.completer.delegate = self
    }

    func update(queryFragment: String) {
        completer.resultTypes = .pointOfInterest
        completer.queryFragment = queryFragment
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completions = completer.results.map { completion in
            // Get the private _mapItem property
            let mapItem = completion.value(forKey: "_mapItem") as? MKMapItem

            return .init(
                title: completion.title,
                subTitle: completion.subtitle,
                url: mapItem?.url
            )
        }
    }

    func search(with query: String, coordinate: CLLocationCoordinate2D? = nil) async throws -> [SearchResult] {
        let mapKitRequest = MKLocalSearch.Request()
        mapKitRequest.naturalLanguageQuery = query
        mapKitRequest.resultTypes = .pointOfInterest
        if let coordinate {
            mapKitRequest.region = .init(.init(origin: .init(coordinate), size: .init(width: 1, height: 1)))
        }
        let search = MKLocalSearch(request: mapKitRequest)

        let response = try await search.start()

        return response.mapItems.compactMap { mapItem in
            guard let location = mapItem.placemark.location?.coordinate else { return nil }

            return .init(location: location)
        }
    }
}


struct ViewShopMap: View {

    @Environment(\.dismiss) private var dismiss
    @State private var position = MapCameraPosition.automatic
    @State private var selectedLocation: SearchResult?

    @Bindable var shop: Shop

    var body: some View {
        NavigationStack {
            ZStack {
                Map(position: $position, selection: $selectedLocation) {
                    Marker(shop.name, systemImage: "house.fill", coordinate: shop.location ?? .init())
                        .tag(selectedLocation)
                }
                .mapStyle(.imagery(elevation: .realistic))
                .ignoresSafeArea()
            }
            .navigationTitle(shop.name)
        }
        .overlay(alignment: .topTrailing) {
            Button {
                dismiss()
            } label: {
                XMarkButton()
            }
        }
        .onAppear {
            selectedLocation = .init(location: shop.location ?? .init())
        }
    }
}
