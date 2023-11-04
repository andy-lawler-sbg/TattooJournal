//
//  Appointment.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import Foundation
import SwiftData
import MapKit

@Model
final class Appointment: Codable {

    let id = UUID().uuidString
    
    var artist: Artist?
    var shop: Shop?

    var date: Date
    var price: String
    var design: String
    var notifyMe: Bool
    var bodyPart: TattooLocation.RawValue

    var notifyMeDescription: String {
        switch notifyMe {
        case true:
            "Notifications On"
        case false:
            "Notifications Off"
        }
    }

    init(artist: Artist? = nil,
         shop: Shop? = nil,
         date: Date = .now,
         price: String = "",
         design: String = "",
         notifyMe: Bool = false,
         bodyPart: TattooLocation.RawValue = TattooLocation.arms.rawValue
    ){
        self.artist = artist
        self.shop = shop
        self.date = date
        self.price = price
        self.design = design
        self.notifyMe = notifyMe
        self.bodyPart = bodyPart
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(artist, forKey: .artist)
        try container.encode(shop, forKey: .shop)
        try container.encode(date, forKey: .date)
        try container.encode(price, forKey: .price)
        try container.encode(design, forKey: .design)
        try container.encode(notifyMe, forKey: .notifyMe)
        try container.encode(bodyPart, forKey: .bodyPart)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        artist = try values.decodeIfPresent(Artist.self, forKey: .artist)
        shop = try values.decodeIfPresent(Shop.self, forKey: .shop)
        date = try values.decode(Date.self, forKey: .date)
        price = try values.decode(String.self, forKey: .price)
        design = try values.decode(String.self, forKey: .design)
        notifyMe = try values.decode(Bool.self, forKey: .notifyMe)
        bodyPart = try values.decode(String.self, forKey: .bodyPart)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case artist
        case shop
        case date
        case price
        case design
        case notifyMe
        case bodyPart
    }

    @Transient
    var tattooLocation: TattooLocation {
        TattooLocation(rawValue: self.bodyPart) ?? .arms
    }
}

enum TattooLocation: String, Codable, CaseIterable {
    case head, neck, arms, legs, front, back, feet

    var displayValue: String {
        self.rawValue.capitalized
    }
}

@Model
final class Artist: Codable {

    @Attribute(.unique) var name: String
    @Attribute(.unique) var instagramHandle: String?
    @Relationship(deleteRule: .nullify, inverse: \Appointment.artist) var appointments = [Appointment]()

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(instagramHandle, forKey: .instagramHandle)
        try container.encode(appointments, forKey: .appointments)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        instagramHandle = try values.decodeIfPresent(String.self, forKey: .instagramHandle)
        appointments = try values.decode([Appointment].self, forKey: .appointments)
    }

    enum CodingKeys: String, CodingKey {
        case name
        case instagramHandle
        case appointment
        case appointments
    }

    init(name: String = "",
         instagramHandle: String? = nil,
         appointments: [Appointment] = []
    ) {
        self.name = name
        self.instagramHandle = instagramHandle
        self.appointments = appointments
    }
}

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
