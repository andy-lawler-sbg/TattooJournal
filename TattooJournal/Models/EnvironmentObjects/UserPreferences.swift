//
//  UserPreferences.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI

@Observable
final class UserPreferences: ObservableObject {

    var currency: Currency {
        Preferences.Constants.currencies[selectedCurrency - 1]
    }

    var currencyString: String {
        Preferences.Constants.currencies[selectedCurrency - 1].value
    }

    var tipAmount: TipAmount {
        Preferences.Constants.tipAmounts[selectedTipAmount - 1]
    }

    var selectedCurrency = 1
    var selectedTipAmount = 1
    var appColor = Color.accentColor

    init() {
        appColor = getColor() ?? Color.accentColor
    }

    func saveUserPreferences() {
        saveColor()
    }

    private func saveColor() {
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
        guard let index = Preferences.Constants.tipAmounts.firstIndex(where: { $0.title == tipAmount.title }) else { return }
        self.selectedTipAmount = index
    }

    func updateCurrency(_ currency: Currency) {
        guard let index = Preferences.Constants.currencies.firstIndex(where: { $0.title == currency.title }) else { return }
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
