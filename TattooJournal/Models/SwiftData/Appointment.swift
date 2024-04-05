//
//  Appointment.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftData
import Foundation

@Model
final class Appointment: Codable {

    let id = UUID().uuidString
    
    var artist: Artist?
    var shop: Shop?
    var review: Review?
    var image: TattooImage?

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

    var reviewDescription: String {
        review == nil ? "No Review" : "Reviewed"
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
