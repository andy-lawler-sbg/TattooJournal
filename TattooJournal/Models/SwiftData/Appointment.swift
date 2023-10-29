//
//  Appointment.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import Foundation
import SwiftData

@Model
final class Appointment: Codable {

    let id = UUID().uuidString
    @Relationship(deleteRule: .nullify, inverse: \Artist.appointments) var artist: Artist?
    @Relationship(deleteRule: .nullify, inverse: \Shop.appointments) var shop: Shop?

    var date = Date()
    var price: String
    var design: String
    var notifyMe: Bool
    var bodyPart: TattooLocation.RawValue

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
    @Attribute(.unique) var instagramHandle: String

    var appointments: [Appointment] = []
    
    @Relationship(deleteRule: .nullify, inverse: \Shop.artists) var shop: Shop?

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(instagramHandle, forKey: .instagramHandle)
        try container.encode(appointments, forKey: .appointments)
        try container.encode(shop, forKey: .shop)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        instagramHandle = try values.decode(String.self, forKey: .instagramHandle)
        appointments = try values.decode([Appointment].self, forKey: .appointments)
        shop = try values.decodeIfPresent(Shop.self, forKey: .shop)
    }

    enum CodingKeys: String, CodingKey {
        case name
        case instagramHandle
        case appointment
        case appointments
        case shop
    }

    init(name: String = "",
         instagramHandle: String = "",
         appointments: [Appointment] = [],
         shop: Shop? = nil
    ) {
        self.name = name
        self.instagramHandle = instagramHandle
        self.appointments = appointments
        self.shop = shop
    }
}

@Model
final class Shop: Codable {
    @Attribute(.unique) var name: String

    var appointments: [Appointment] = []
    var artists: [Artist] = []

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(appointments, forKey: .appointments)
        try container.encode(artists, forKey: .artists)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        appointments = try values.decode([Appointment].self, forKey: .appointments)
        artists = try values.decode([Artist].self, forKey: .artists)
    }

    enum CodingKeys: String, CodingKey {
        case name
        case appointments
        case artists
    }

    init(name: String = "",
         appointments: [Appointment] = [],
         artists: [Artist] = []
    ) {
        self.name = name
        self.appointments = appointments
        self.artists = artists
    }
}
