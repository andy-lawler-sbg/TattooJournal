//
//  Shop.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import Foundation

struct Shop: Identifiable, Hashable {
    let id = UUID()
    var location: Location?
    var title: String = ""
}
