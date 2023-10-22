//
//  Preferences.swift
//  TattooJournal
//
//  Created by Andrew Lawler on 22/10/2023.
//

import SwiftData
import SwiftUI

@Model
final class Preferences: Codable {
    var currency: Currency
    var tipAmount: TipAmount
    var appColor: AppColor

    init(currency: Currency = Constants.currencies[0],
         tipAmount: TipAmount = Constants.tipAmounts[0],
         appColor: AppColor
    ) {
        self.currency = currency
        self.tipAmount = tipAmount
        self.appColor = appColor
    }

    enum CodingKeys: String, CodingKey {
        case currency
        case tipAmount
        case appColor
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(currency, forKey: .currency)
        try container.encode(tipAmount, forKey: .tipAmount)
        try container.encode(appColor, forKey: .appColor)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        currency = try values.decode(Currency.self, forKey: .currency)
        tipAmount = try values.decode(TipAmount.self, forKey: .tipAmount)
        appColor = try values.decode(AppColor.self, forKey: .appColor)
    }

    var appTint: Color {
        Color(red: appColor.red, green: appColor.green, blue: appColor.blue)
    }

    var currencyString: String {
        currency.value
    }

    enum Constants {
        static var currencies = [
            Currency(id: 1, title: "sterling", value: "£"),
            Currency(id: 2, title: "euro", value: "€"),
            Currency(id: 3, title: "dollar", value: "$")
        ]

        static var tipAmounts = [
            TipAmount(id: 1, title: "10%", amount: 10),
            TipAmount(id: 2, title: "20%", amount: 20),
            TipAmount(id: 3, title: "30%", amount: 30),
            TipAmount(id: 3, title: "30%", amount: 40)
        ]
    }
}

final class AppColor: Codable, Equatable {
    let red: Double
    let green: Double
    let blue: Double

    init(red: Double, green: Double, blue: Double) {
        self.red = red
        self.green = green
        self.blue = blue
    }

    enum CodingKeys: String, CodingKey {
        case red
        case green
        case blue
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(red, forKey: .red)
        try container.encode(green, forKey: .green)
        try container.encode(blue, forKey: .blue)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        red = try values.decode(Double.self, forKey: .red)
        green = try values.decode(Double.self, forKey: .green)
        blue = try values.decode(Double.self, forKey: .blue)
    }

    static func == (lhs: AppColor, rhs: AppColor) -> Bool {
        lhs.red == rhs.red &&
        lhs.green == rhs.green &&
        lhs.blue == rhs.blue
    }
}

final class Currency: Codable, Equatable {
    let id: Int
    let title: String
    let value: String

    init(id: Int, title: String, value: String) {
        self.id = id
        self.title = title
        self.value = value
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case value
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(value, forKey: .value)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        value = try values.decode(String.self, forKey: .value)
    }

    static func == (lhs: Currency, rhs: Currency) -> Bool {
        lhs.title == rhs.title &&
        lhs.id == rhs.id &&
        lhs.value == rhs.value
    }
}

final class TipAmount: Codable, Equatable {
    let id: Int
    let title: String
    let amount: Int

    init(id: Int, title: String, amount: Int) {
        self.id = id
        self.title = title
        self.amount = amount
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case amount
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(amount, forKey: .amount)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        amount = try values.decode(Int.self, forKey: .amount)
    }

    static func == (lhs: TipAmount, rhs: TipAmount) -> Bool {
        lhs.title == rhs.title &&
        lhs.id == rhs.id &&
        lhs.amount == rhs.amount
    }
}
