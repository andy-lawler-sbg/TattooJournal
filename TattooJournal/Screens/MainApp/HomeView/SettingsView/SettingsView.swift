//
//  SettingsView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI

struct SettingsView: View {

    @EnvironmentObject var userPreferences: UserPreferences

    @Binding var isShowingSettingsView: Bool

    @State var selectedCurrencyIndex = 0
    @State var selectedTipAmount = 0

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Currency", selection: $userPreferences.selectedCurrency) {
                        ForEach(userPreferences.currencies, id: \.id) { currency in
                            Text(currency.value)
                        }
                    }
                    Picker("Tip Amount", selection: $userPreferences.selectedTipAmount) {
                        ForEach(userPreferences.tipAmounts, id: \.id) { tipAmount in
                            Text(tipAmount.title)
                        }
                    }
                    ColorPicker("App Tint", selection: $userPreferences.appColor)
                    Button {
                        userPreferences.saveColor()
                    } label: {
                        Text("Save Changes")
                            .multilineTextAlignment(.center)
                            .tint(userPreferences.appColor)
                    }
                } header: {
                    Text("Preferences")
                } footer: {
                    Text("Change your preferences and app settings here.")
                       .font(.caption)
                       .foregroundColor(.gray)
                }
            }
            .formStyle(.grouped)
            .navigationTitle("⚙️ Settings")
        }
        .overlay(Button {
            isShowingSettingsView = false
        } label: {
            XMarkButton()
        }, alignment: .topTrailing)
    }
}

#Preview {
    SettingsView(isShowingSettingsView: .constant(true))
        .modifier(PreviewEnvironmentObjects())
}
