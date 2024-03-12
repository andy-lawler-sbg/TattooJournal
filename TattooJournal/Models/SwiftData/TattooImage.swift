//
//  TattooImage.swift
//  TattooJournal
//
//  Created by Andy Lawler on 18/11/2023.
//

import Foundation
import SwiftData

@Model
final class TattooImage: Codable {
    
    var date: Date
    @Attribute(.unique) var image: Data
    @Relationship(deleteRule: .nullify, inverse: \Appointment.image) var appointment: Appointment?

    init(date: Date = .now,
         image: Data = .init(),
         appointment: Appointment? = nil
    ) {
        self.date = date
        self.image = image
        self.appointment = appointment
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(image, forKey: .image)
        try container.encode(appointment, forKey: .appointment)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decode(Date.self, forKey: .date)
        image = try values.decode(Data.self, forKey: .image)
        appointment = try values.decodeIfPresent(Appointment.self, forKey: .appointment)
    }

    enum CodingKeys: String, CodingKey {
        case date
        case image
        case appointment
    }
}
