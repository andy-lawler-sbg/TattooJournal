//
//  SettingsView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI

struct SettingsItemView<Content: View>: View {

    var itemView: Content
    var imageName: String
    var color: Color

    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(color)
                Image(systemName: imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(Color.white)
                    .padding(8)
            }
            .frame(width: 35, height: 35)
            itemView
        }.padding(.vertical, 2)
    }
}

struct SettingsView: View {

    @EnvironmentObject var userPreferences: UserPreferences

    var selectedCurrency: Int { userPreferences.selectedCurrency }
    var tipAmount: TipAmount { userPreferences.tipAmount }
    var appTint: Color { userPreferences.appColor }

    @Binding var isShowingSettingsView: Bool

    @State var selectedCurrencyIndex = 0
    @State var selectedTipAmount = 0

    var body: some View {
        NavigationStack {
            Form {
                Section {
// Theme
//                    SettingsItemView(itemView: currencyPicker,
//                                     imageName: "lightbulb.max.fill",
//                                     color: Color(uiColor: .lightGray))
                    SettingsItemView(itemView: currencyPicker,
                                     imageName: currencyIconName,
                                     color: .orange)
                    SettingsItemView(itemView: tipAmountPicker,
                                     imageName: "banknote.fill",
                                     color: .green)
                    SettingsItemView(itemView: colorPicker,
                                     imageName: "paintbrush.fill",
                                     color: userPreferences.appColor)
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
                    Text("Save must be pressed for changes to be applied.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .formStyle(.grouped)
            .navigationTitle("Settings")
        }
        .overlay(Button {
            isShowingSettingsView = false
        } label: {
            XMarkButton()
        }, alignment: .topTrailing)
    }

    private var colorPicker: some View {
        ColorPicker("App Tint", selection: $userPreferences.appColor)
    }

    private var currencyPicker: some View {
        Picker("Currency", selection: $userPreferences.selectedCurrency) {
            ForEach(Preferences.Constants.currencies, id: \.id) { currency in
                Text(currency.value)
            }
        }
    }

    private var currencyIconName: String {
        "\(userPreferences.currency.title)sign"
    }

    private var tipAmountPicker: some View {
        Picker("Tip Amount", selection: $userPreferences.selectedTipAmount) {
            ForEach(Preferences.Constants.tipAmounts, id: \.id) { tipAmount in
                Text(tipAmount.title)
            }
        }
    }
}

#Preview {
    SettingsView(isShowingSettingsView: .constant(true))
        .modifier(PreviewEnvironmentObjects())
}
