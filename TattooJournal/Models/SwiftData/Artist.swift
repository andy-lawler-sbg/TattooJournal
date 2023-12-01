//
//  Artist.swift
//  TattooJournal
//
//  Created by Andy Lawler on 09/11/2023.
//

import SwiftData

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
