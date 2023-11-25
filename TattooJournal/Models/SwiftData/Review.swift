//
//  Review.swift
//  TattooJournal
//
//  Created by Andy Lawler on 09/11/2023.
//

import SwiftData

@Model
final class Review: Codable {

    var rating: Int

    @Relationship(deleteRule: .nullify, inverse: \Appointment.review) var appointment: Appointment?

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(rating, forKey: .rating)
        try container.encode(appointment, forKey: .appointment)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        rating = try values.decode(Int.self, forKey: .rating)
        appointment = try values.decodeIfPresent(Appointment.self, forKey: .appointment)
    }

    enum CodingKeys: String, CodingKey {
        case rating
        case review
        case appointment
    }

    init(rating: Int = 1,
         appointment: Appointment? = nil
    ) {
        self.rating = rating
        self.appointment = appointment
    }
}
