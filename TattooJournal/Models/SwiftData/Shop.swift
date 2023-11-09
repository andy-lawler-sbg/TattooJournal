//
//  Shop.swift
//  TattooJournal
//
//  Created by Andy Lawler on 09/11/2023.
//

import SwiftData
import MapKit

@Model
final class Shop: Codable {

    @Attribute(.unique) var name: String
    var locationLatitude: Double?
    var locationLongitude: Double?

    @Relationship(deleteRule: .nullify, inverse: \Appointment.shop) var appointments = [Appointment]()

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(appointments, forKey: .appointments)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        locationLatitude = try values.decodeIfPresent(Double.self, forKey: .locationLatitude)
        locationLongitude = try values.decodeIfPresent(Double.self, forKey: .locationLongitude)
        appointments = try values.decode([Appointment].self, forKey: .appointments)
    }

    enum CodingKeys: String, CodingKey {
        case name
        case locationLatitude
        case locationLongitude
        case appointments
    }

    init(name: String = "",
         locationLatitude: Double? = nil,
         locationLongitude: Double? = nil,
         appointments: [Appointment] = []
    ) {
        self.name = name
        self.locationLatitude = locationLatitude
        self.locationLongitude = locationLongitude
        self.appointments = appointments
    }

    @Transient
    var location: CLLocationCoordinate2D? {
        guard let locationLatitude, let locationLongitude else { return nil }
        return .init(latitude: locationLatitude, longitude: locationLongitude)
    }
}

