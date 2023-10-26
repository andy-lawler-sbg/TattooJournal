//
//  UserPreferences.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI
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

@Observable
final class AppThemeHandler: ObservableObject {
    var appColor = Color.accentColor
    var selectedThemeType: ThemeType.RawValue?

    var selectedTheme: ThemeType {
        guard let selectedThemeType, 
              let type = ThemeType(rawValue: selectedThemeType) 
        else { return .system }
        return type
    }

    var colorScheme: ColorScheme? {
        switch selectedTheme {
        case .light:
            return .light
        case .dark:
            return .dark
        default:
            return nil
        }
    }

    init() {
        appColor = getColor() ?? Color.accentColor
        selectedThemeType = getTheme()
    }

    // MARK: - Save & Reset

    func saveThemes() {
        saveColor()
        saveTheme()
    }

    func reset() {
        UserDefaults.standard.removeObject(forKey: Constants.appColorKey)
        UserDefaults.standard.removeObject(forKey: Constants.appThemeKey)
        appColor = Color.accentColor
        selectedThemeType = ThemeType.system.rawValue
    }

    // MARK: - Color Handling

    private func saveColor() {
        guard let cgColor = appColor.cgColor,
              let array = cgColor.components
        else {
            print("🎨 Failed to save new theme 🎨")
            return
        }
        UserDefaults.standard.set(array, forKey: Constants.appColorKey)
    }

    private func getColor() -> Color? {
        guard let array = UserDefaults.standard.object(forKey: Constants.appColorKey) as? [CGFloat],
              let cgColor = CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: array)
        else {
            print("⚠️ No colour found in your defaults, using original ⚠️")
            return nil
        }
        return Color(cgColor)
    }

    // MARK: - Theme Handling

    private func saveTheme() {
        UserDefaults.standard.set(selectedThemeType, forKey: Constants.appThemeKey)
    }

    private func getTheme() -> Int {
        UserDefaults.standard.integer(forKey: Constants.appThemeKey)
    }
}

private extension AppThemeHandler {
    enum Constants {
        static let appColorKey = "appColor"
        static let appThemeKey = "appTheme"
    }
}

enum ThemeType: Int, Identifiable, CaseIterable {
    var id: Self { self }
    case system
    case light
    case dark

    var title: String {
        switch self {
        case .system:
            return "System"
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
    }

    var themeIcon: String {
        switch self {
        case .light:
            return "sun.max"
        case .dark:
            return "moon.fill"
        default:
            return "paintpalette.fill"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        default:
            return nil
        }
    }
}

extension UserDefaults {
    func color(forKey key: String) -> Color {
        guard let array = object(forKey: key) as? [CGFloat] else { return .accentColor }
        let color = CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: array)!
        return Color(color)
    }
}
