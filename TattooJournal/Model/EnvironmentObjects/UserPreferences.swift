//
//  UserPreferences.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI

struct Currency: Identifiable, Hashable {
    let id: Int
    let title: String
    let value: String
}

struct TipAmount: Identifiable, Hashable {
    let id: Int
    let title: String
    let amount: Int
}

final class UserPreferences: ObservableObject {

    var currencies = [
        Currency(id: 1, title: "pound", value: "£"),
        Currency(id: 2, title: "euro", value: "€"),
        Currency(id: 3, title: "dollar", value: "$")
    ]

    var tipAmounts = [
        TipAmount(id: 1, title: "%10", amount: 10),
        TipAmount(id: 2, title: "%20", amount: 20),
        TipAmount(id: 3, title: "%30", amount: 30)
    ]

    var currency: Currency {
        currencies[selectedCurrency - 1]
    }

    var currencyString: String {
        currencies[selectedCurrency - 1].value
    }

    var tipAmount: TipAmount {
        tipAmounts[selectedTipAmount - 1]
    }

    @Published var selectedCurrency = 1
    @Published var selectedTipAmount = 1

    func updateTipAmount(_ tipAmount: TipAmount) {
        guard let index = tipAmounts.firstIndex(where: { $0.title == tipAmount.title }) else { return }
        self.selectedTipAmount = index
    }

    func updateCurrency(_ currency: Currency) {
        guard let index = currencies.firstIndex(where: { $0.title == currency.title }) else { return }
        self.selectedCurrency = index
    }
}
