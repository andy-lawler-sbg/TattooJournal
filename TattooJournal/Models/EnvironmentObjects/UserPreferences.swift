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

enum Preferences {
    static var currencies = [
        Currency(id: 1, title: "pound", value: "£"),
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

@Observable 
final class UserPreferences: ObservableObject {

    var currency: Currency {
        Preferences.currencies[selectedCurrency - 1]
    }

    var currencyString: String {
        Preferences.currencies[selectedCurrency - 1].value
    }

    var tipAmount: TipAmount {
        Preferences.tipAmounts[selectedTipAmount - 1]
    }

    var selectedCurrency = 1
    var selectedTipAmount = 1
    var appColor = Color.accentColor

    init() {
        appColor = getColor() ?? Color.accentColor
    }

    func saveColor() {
        guard let cgColor = appColor.cgColor,
              let array = cgColor.components else { return }
        UserDefaults.standard.set(array, forKey: "appColor")
    }

    func getColor() -> Color? {
        guard let array = UserDefaults.standard.object(forKey: "appColor") as? [CGFloat],
              let cgColor = CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: array)
        else { return nil }
        return Color(cgColor)
    }

    func updateTipAmount(_ tipAmount: TipAmount) {
        guard let index = Preferences.tipAmounts.firstIndex(where: { $0.title == tipAmount.title }) else { return }
        self.selectedTipAmount = index
    }

    func updateCurrency(_ currency: Currency) {
        guard let index = Preferences.currencies.firstIndex(where: { $0.title == currency.title }) else { return }
        self.selectedCurrency = index
    }
}

extension UserDefaults {
    func color(forKey key: String) -> Color {
        guard let array = object(forKey: key) as? [CGFloat] else { return .accentColor }
        let color = CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: array)!
        return Color(color)
    }
}
