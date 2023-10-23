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
    @Relationship(inverse: \Artist.appointment) var artist: Artist?
    @Relationship(inverse: \Shop.appointment) var shop: Shop?
    var date = Date()
    var price: String
    var design: String
    var notifyMe: Bool

    init(artist: Artist? = nil,
         shop: Shop? = nil,
         date: Date = .now,
         price: String = "",
         design: String = "",
         notifyMe: Bool = false) {
        self.artist = artist
        self.shop = shop
        self.date = date
        self.price = price
        self.design = design
        self.notifyMe = notifyMe
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(artist, forKey: .artist)
        try container.encode(shop, forKey: .shop)
        try container.encode(date, forKey: .date)
        try container.encode(price, forKey: .price)
        try container.encode(design, forKey: .design)
        try container.encode(notifyMe, forKey: .notifyMe)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        artist = try values.decodeIfPresent(Artist.self, forKey: .artist)
        shop = try values.decodeIfPresent(Shop.self, forKey: .shop)
        date = try values.decode(Date.self, forKey: .date)
        price = try values.decode(String.self, forKey: .price)
        design = try values.decode(String.self, forKey: .design)
        notifyMe = try values.decode(Bool.self, forKey: .notifyMe)
    }

    enum CodingKeys: String, CodingKey {
        case artist
        case shop
        case date
        case price
        case design
        case notifyMe
    }
}

@Model
class Artist: Codable {
    var name: String
    var appointment: Appointment?

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(appointment, forKey: .appointment)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        appointment = try values.decodeIfPresent(Appointment.self, forKey: .appointment)
    }

    enum CodingKeys: String, CodingKey {
        case name
        case shop
        case appointment
    }

    init(name: String = "",
         appointment: Appointment? = nil
    ) {
        self.name = name
        self.appointment = appointment
    }
}

@Model
class Shop: Codable {
    var name: String
    var contactNumber: String
    var appointment: Appointment?

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(contactNumber, forKey: .contactNumber)
        try container.encode(appointment, forKey: .appointment)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        contactNumber = try values.decode(String.self, forKey: .contactNumber)
        appointment = try values.decodeIfPresent(Appointment.self, forKey: .appointment)
    }

    enum CodingKeys: String, CodingKey {
        case name
        case contactNumber
        case appointment
    }

    init(name: String = "",
         contactNumber: String = "",
         appointment: Appointment? = nil
    ) {
        self.name = name
        self.contactNumber = contactNumber
        self.appointment = appointment
    }
}