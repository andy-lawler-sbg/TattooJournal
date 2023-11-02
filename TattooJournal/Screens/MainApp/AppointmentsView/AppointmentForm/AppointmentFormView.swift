//
//  AppointmentFormView.swift
//  TattooJournal
//
//  Created by Andrew Lawler on 22/10/2023.
//

import SwiftUI
import SwiftData

enum AppointmentFormType {
    case create, update
}

struct AppointmentFormView: View {

    @Query private var artists: [Artist]
    @Query private var shops: [Shop]

    @EnvironmentObject var themeHandler: AppThemeHandler
    @Environment(\.dismiss) var dismiss

    @State private var alertType: FormValidationError? {
        didSet {
            showingAlert = !(alertType == nil)
        }
    }
    @State private var showingAlert: Bool = false

    @FocusState private var focusedTextField: FormTextField?
    enum FormTextField {
        case artistName, artistInstagramHandle, price, design, shopName
    }

    // MARK: - Inputs

    var type: AppointmentFormType
    @Binding var date: Date

    @Binding var artist: Artist?
    @Binding var artistName: String
    @Binding var artistInstagramHandle: String

    @Binding var price: String
    @Binding var design: String
    @Binding var tattooLocation: TattooLocation

    @Binding var notifyMe: Bool

    @Binding var shop: Shop?
    @Binding var shopName: String

    var buttonAction: (() -> Void)

    var body: some View {
        NavigationStack {
            Form {
                dateAndLocationSection
                artistSection
                keyDetailsSection
                shopSection
                notificationSection
                actionButtonSections
            }
            .navigationTitle("\(type == .create ? "Log" : "Update") Appointment")
            .background(Color(.background))
        }
        .alert(alertType?.title ?? "Generic Error", isPresented: $showingAlert, actions: {
            Button {
                withAnimation {
                    guard let alertType else { return }
                    switch alertType {
                    case .noPrice:
                        price = ""
                    case .multipleErrors(let errors):
                        if errors.contains(.noPrice) {
                            price = ""
                        }
                    default:
                        break
                    }
                    dismissAlerts()
                }
            } label: {
                Text("Ok")
            }.tint(themeHandler.appColor)
        }, message: {
            if let alertType {
                Text(alertType.description)
            }
        })
        .overlay(
            Button {
                dismiss()
            } label: {
               XMarkButton()
            }, alignment: .topTrailing
        )
    }

    private var dateAndLocationSection: some View {
        Section {
            /// id is added to make the picker close when the selection is made
            DatePicker("Date", selection: $date)
                .id(date.timeIntervalSince1970)
        } header: {
            Text("Date & Location")
        } footer: {
            Text("Only future dates are allowed.")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }

    private var artistSection: some View {
        Section {
            if !artists.isEmpty {
                Picker("Artist", selection: $artist) {
                    ForEach(artists, id: \.self) { artist in
                        Text(artist.name)
                            .tag(artist as Artist?)
                    }
                    Text("👨🏻‍🎨 New 👨🏻‍🎨")
                        .tag(nil as Artist?)
                }
            }
            if artist == nil || artists.isEmpty {
                TextField("Artist Name", text: $artistName)
                    .focused($focusedTextField, equals: .artistName)
                    .onSubmit { focusedTextField = .artistInstagramHandle }
                    .submitLabel(.next)
                    .autocorrectionDisabled()
                TextField("Instagram @", text: $artistInstagramHandle)
                    .focused($focusedTextField, equals: .artistInstagramHandle)
                    .onSubmit { focusedTextField = .price }
                    .submitLabel(.next)
                    .autocorrectionDisabled()
                    .overlay(alignment: .trailing) {
                        Text("Optional")
                            .font(.caption)
                            .italic()
                            .foregroundStyle(.tertiary)
                    }
            }
        } header: {
            Text("Artist Details")
        }
    }

    private var shopSection: some View {
        Section {
            if !shops.isEmpty {
                Picker("Shop", selection: $shop) {
                    ForEach(shops, id: \.self) { shop in
                        Text(shop.name)
                            .tag(shop as Shop?)
                    }
                    Text("🏪 New 🏪")
                        .tag(nil as Shop?)
                }
            }
            if shop == nil || shops.isEmpty {
                TextField("Shop Name", text: $shopName)
                    .focused($focusedTextField, equals: .shopName)
                    .onSubmit { focusedTextField = nil }
                    .submitLabel(.continue)
                NavigationLink {
                    ShopMapView()
                } label: {
                    Text("Shop Location")
                }
            }
        } header: {
            Text("Shop Details")
        }
    }

    private var keyDetailsSection: some View {
        Section {
            TextField("Price", text: $price)
                .keyboardType(.numbersAndPunctuation)
                .focused($focusedTextField, equals: .price)
                .onSubmit { focusedTextField = .design }
                .submitLabel(.next)
            TextField("Design", text: $design)
                .focused($focusedTextField, equals: .design)
                .onSubmit { focusedTextField = nil }
                .submitLabel(.continue)
            Picker("Body Part", selection: $tattooLocation) {
                ForEach(TattooLocation.allCases, id: \.self) { tattooLocation in
                    Text(tattooLocation.displayValue)
                }
            }
        } header: {
            Text("Appointment Details")
        } footer: {
            Text("This includes your artist, price, design & body part fields.")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }

    private var notificationSection: some View {
        Section {
            Toggle("Notify Me", isOn: $notifyMe)
                .tint(themeHandler.appColor)
        } header: {
            Text("Notifications")
        } footer: {
            Text("Turn this on to receive reminder notifications before your appointment.")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }

    private var actionButtonSections: some View {
        Section {
            Button {
                Task {
                    do {
                        try await validateUserInput()
                        withAnimation(.snappy) {
                            buttonAction()
                            dismiss()
                        }
                    } catch {
                        if let error = error as? FormValidationError {
                            withAnimation {
                                alertType = error
                            }
                        }
                    }
                }
            } label: {
                Text(type == .create ? "Create" : "Update")
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
            }
        }
    }

    // MARK: - Error Handling

    private func validateUserInput() async throws {
        var errorsToThrow = [FormValidationError]()
        if datesMatch(dateOne: date, dateTwo: Date.now) || date < Date.now {
            errorsToThrow.append(FormValidationError.invalidDate)
        }
        if artist == nil && artistName.isEmpty {
            errorsToThrow.append(FormValidationError.noArtist)
        }
        if let _ = Double(price) {} else {
            errorsToThrow.append(FormValidationError.noPrice)
        }
        if design.isEmpty {
            errorsToThrow.append(FormValidationError.noDesign)
        }
        if shop == nil && shopName.isEmpty {
            errorsToThrow.append(FormValidationError.noArtist)
        }
        if errorsToThrow.count > 1 {
            throw FormValidationError.multipleErrors(errors: errorsToThrow)
        } else if let error = errorsToThrow.first {
            throw error
        }
    }

    private func datesMatch(dateOne: Date, dateTwo: Date) -> Bool {
        let dateOneComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: dateOne)
        let dateTwoComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: dateTwo)
        if dateOneComponents.day == dateTwoComponents.day
            && dateOneComponents.month == dateTwoComponents.month
            && dateOneComponents.year == dateTwoComponents.year
            && dateOneComponents.hour == dateTwoComponents.hour
            && dateOneComponents.minute == dateTwoComponents.minute {
            return true
        } else {
            return false
        }
    }


    private func dismissAlerts() {
        alertType = nil
    }

    enum FormValidationError: Error, Equatable {
        case invalidDate
        case noArtist
        case noPrice
        case noDesign
        case noShop
        case multipleErrors(errors: [FormValidationError])

        var title: String {
            switch self {
            case .invalidDate:
                return "📅 Invalid Date 📅"
            case .noArtist:
                return "👨‍🎨 No Artist Entered 👨‍🎨"
            case .noPrice:
                return "💰 No Valid Price Entered 💰"
            case .noDesign:
                return "🎨 No Design Entered 🎨"
            case .multipleErrors:
                return "⚠️ Multiple Errors ⚠️"
            case .noShop:
                return "🏚️ No Shop Entered 🏚️"
            }
        }

        var description: String {
            switch self {
            case .invalidDate:
                return "Please enter a date in the future."
            case .noArtist:
                return "Please enter your artist."
            case .noPrice:
                return "Please enter a valid price."
            case .noDesign:
                return "Please enter your design details."
            case .multipleErrors(let errors):
                var errorString = ""
                for (index, error) in errors.enumerated() {
                    guard let errorSubtitle = error.errorSubtitle else { break }
                    let count = errors.count
                    errorString += errorSubtitle
                    if index == count - 2 {
                        errorString += " & "
                    } else if index != count - 1 {
                        errorString += ", "
                    }
                }
                return "Please fill in the \(errorString) fields."
            case .noShop:
                return "Please enter a shop"
            }
        }

        var errorSubtitle: String? {
            switch self {
            case .invalidDate:
                return "date"
            case .noArtist:
                return "artist"
            case .noDesign:
                return "design"
            case .noPrice:
                return "price"
            case .noShop:
                return "shop"
            default:
                return nil
            }
        }
    }
}

#Preview {
    AppointmentFormView(type: .create,
                        date: .constant(.now),
                        artist: .constant(Artist()),
                        artistName: .constant("Andy Lawler"),
                        artistInstagramHandle: .constant(""),
                        price: .constant("250"),
                        design: .constant("Eagle"),
                        tattooLocation: .constant(.arms), notifyMe: .constant(true),
                        shop: .constant(Shop()),
                        shopName: .constant(""),
                        buttonAction: {}
    )
}
