//
//  UserPreferences.swift
//  TattooJournal
//
//  Created by Andy Lawler on 09/11/2023.
//

import SwiftData

@Model
final class UserPreferences: Codable {
    var currencyString: CurrencyType.RawValue
    var tipAmountString: TipAmountType.RawValue

    init(currencyString: CurrencyType.RawValue = CurrencyType.sterling.rawValue,
         tipAmountString: TipAmountType.RawValue = TipAmountType.tenPercent.rawValue
    ) {
        self.currencyString = currencyString
        self.tipAmountString = tipAmountString
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(currencyString, forKey: .currencyString)
        try container.encode(tipAmountString, forKey: .tipAmountString)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        currencyString = try values.decode(String.self, forKey: .currencyString)
        tipAmountString = try values.decode(String.self, forKey: .tipAmountString)
    }

    enum CodingKeys: String, CodingKey {
        case currencyString
        case tipAmountString
    }

    @Transient
    var currency: CurrencyType {
        CurrencyType(rawValue: self.currencyString) ?? .sterling
    }

    @Transient
    var tipAmount: TipAmountType {
        TipAmountType(rawValue: self.tipAmountString) ?? .tenPercent
    }
}

enum CurrencyType: String, Codable, CaseIterable {
    case sterling, euro, dollar

    var displayValue: String {
        switch self {
        case .sterling:
            return "£"
        case .euro:
            return "€"
        case .dollar:
            return "$"
        }
    }
}

enum TipAmountType: String, Codable, CaseIterable {
    case tenPercent, twentyPercent, thirtyPercent, fourtyPercent

    var intValue: Int {
        switch self {
        case .tenPercent:
            return 10
        case .twentyPercent:
            return 20
        case .thirtyPercent:
            return 30
        case .fourtyPercent:
            return 40
        }
    }

    var displayValue: String {
        "\(self.intValue)%"
    }
}

