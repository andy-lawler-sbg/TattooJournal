//
//  Location.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import Foundation

struct Location: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var name: String
    var description: String
    let latitude: Double
    let longitude: Double
}
