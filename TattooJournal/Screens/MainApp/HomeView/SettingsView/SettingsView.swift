//
//  SettingsView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI
import SwiftData

struct SettingsView: View {

    @EnvironmentObject private var themeHandler: AppThemeHandler

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @State private var selectedAppTheme: ThemeType = .system
    @State private var selectedAppColor: Color = .accentColor
    @State private var selectedCurrency: CurrencyType = .sterling
    @State private var selectedTipAmount: TipAmountType = .tenPercent

    @Query private var queriedUserPreferences: [UserPreferences]
    private var userPreferences: UserPreferences {
        queriedUserPreferences.first!
    }

    var body: some View {
        NavigationStack {
            Form {
                themeSection
                preferencesSection
                saveSection
                socialsSection
                resetSection
            }
            .formStyle(.grouped)
            .navigationTitle(Constants.title)
        }
        .overlay(Button {
            dismiss()
        } label: {
            XMarkButton()
        }, alignment: .topTrailing)
        .onAppear {
            selectedAppTheme = themeHandler.selectedTheme
            selectedAppColor = themeHandler.appColor
            selectedCurrency = userPreferences.currency
            selectedTipAmount = userPreferences.tipAmount
        }
        .preferredColorScheme(selectedAppTheme.colorScheme)
    }

    // MARK: - Theme

    private var themeSection: some View {
        Section {
            SettingsItemView(itemView: themePicker,
                             imageName: themeIconName,
                             backgroundColor: themeBackgroundColor)
            SettingsItemView(itemView: colorPicker,
                             imageName: "paintbrush.fill",
                             backgroundColor: selectedAppColor)
        } header: {
            Text("Theme")
        } footer: {
            Text("App tint can be controlled by light and dark mode or you can set it yourself.")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }

    private var themePicker: some View {
        Picker("Theme", selection: $selectedAppTheme) {
            ForEach(ThemeType.allCases, id: \.self) { theme in
                Text(theme.title)
            }
        }
    }

    private var themeIconName: String {
        switch selectedAppTheme {
        case .system:
            return colorScheme == .light ? ThemeType.light.themeIcon : ThemeType.dark.themeIcon
        case .light, .dark:
            return selectedAppTheme.themeIcon
        }
    }

    private var themeBackgroundColor: Color {
        let lightColor = Color.blue
        let darkColor = Color.gray
        switch selectedAppTheme {
        case .system:
            return colorScheme == .light ? lightColor : darkColor
        case .light:
            return lightColor
        case .dark:
            return darkColor
        }
    }

    private var colorPicker: some View {
        ColorPicker("Color", selection: $selectedAppColor)
    }

    // MARK: - Preferences

    private var preferencesSection: some View {
        Section {
            SettingsItemView(itemView: currencyPicker,
                             imageName: currencyIconName,
                             backgroundColor: .orange)
            SettingsItemView(itemView: tipAmountPicker,
                             imageName: "banknote.fill",
                             backgroundColor: .green)
        } header: {
            Text("Preferences")
        } footer: {
            Text("Make changes to your currency and tip amounts here.")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }

    private var currencyPicker: some View {
        Picker("Currency", selection: $selectedCurrency) {
            ForEach(CurrencyType.allCases, id: \.self) { currency in
                Text(currency.displayValue)
            }
        }
    }

    private var currencyIconName: String {
        "\(selectedCurrency.rawValue)sign"
    }

    private var tipAmountPicker: some View {
        Picker("Tip Amount", selection: $selectedTipAmount) {
            ForEach(TipAmountType.allCases, id: \.self) { tipAmount in
                Text(tipAmount.displayValue)
            }
        }
    }

    // MARK: - Save & Reset

    private var saveSection: some View {
        Section {
            Button {
                themeHandler.appColor = selectedAppColor
                themeHandler.selectedThemeType = selectedAppTheme.rawValue
                themeHandler.saveThemes()

                userPreferences.currencyString = selectedCurrency.rawValue
                userPreferences.tipAmountString = selectedTipAmount.rawValue

                dismiss()
            } label: {
                Text("Save Changes")
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.pink)
            }
        } footer: {
            Text("Save must be pressed for changes to be applied next time you launch the app.")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }

    private var resetSection: some View {
        Section {
            Button {
                themeHandler.reset()

                context.delete(userPreferences)
                let userPreferences = UserPreferences()
                context.insert(userPreferences)
                try? context.save()

                dismiss()
            } label: {
                Text("Reset")
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .tint(.red)
            }
        } footer: {
            VStack {
                Text("Want to reset the app back to it's original state? You can here.")
                    .font(.caption)
                    .foregroundColor(.gray)
                versionAndInfoView
            }
        }
    }

    // MARK: - Socials

    private var socialLink: some View {
        Link("Developer", destination: URL(string: "https://www.x.com/andylawlerdev")!)
            .foregroundStyle(.primary)
    }

    private var socialsSection: some View {
        Section {
            SettingsItemView(itemView: socialLink, imageName: "person.fill", backgroundColor: .blue)
        } header: {
            Text("Developer Socials")
        } footer: {
            Text("Find out more about me.")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }

    // MARK: - Version & Info

    private var versionAndInfoView: some View {
        VStack(spacing: 10) {
            Text("v1.0.0")
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .font(.callout)
                .foregroundStyle(.primary)
            Text("Made in the 🇬🇧.")
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical)
    }
}

private extension SettingsView {
    enum Constants {
        static let title = "Settings"
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppThemeHandler())
}
