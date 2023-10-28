//
//  AppointmentFormView.swift
//  TattooJournal
//
//  Created by Andrew Lawler on 22/10/2023.
//

import SwiftUI

enum AppointmentFormType {
    case create, update
}

struct AppointmentFormView: View {
    
    @EnvironmentObject var themeHandler: AppThemeHandler
    @Environment(\.dismiss) var dismiss

    @State private var alertType: FormValidationError? {
        didSet {
            showingAlert = !(alertType == nil)
        }
    }
    @State private var showingAlert: Bool = false

    var type: AppointmentFormType
    @Binding var date: Date
    @Binding var name: String
    @Binding var price: String
    @Binding var design: String
    @Binding var notifyMe: Bool    
    @Binding var tattooLocation: TattooLocation

    var buttonAction: (() -> Void)

    @FocusState private var focusedTextField: FormTextField?
    enum FormTextField {
        case artist, price, design
    }

    var body: some View {
        NavigationStack {
            Form {
                keyDetailsSection
                dateAndLocationSection
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

    private var keyDetailsSection: some View {
        Section {
            TextField("Artist", text: $name)
                .focused($focusedTextField, equals: .artist)
                .onSubmit { focusedTextField = .price }
                .submitLabel(.next)
                .autocorrectionDisabled()
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
        if name.isEmpty {
            errorsToThrow.append(FormValidationError.noArtist)
        }
        if design.isEmpty {
            errorsToThrow.append(FormValidationError.noDesign)
        }
        if let _ = Double(price) {} else {
            errorsToThrow.append(FormValidationError.noPrice)
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
            default:
                return nil
            }
        }
    }
}

#Preview {
    AppointmentFormView(type: .create,
                        date: .constant(.now),
                        name: .constant("Andy Lawler"),
                        price: .constant("250"),
                        design: .constant("Eagle"),
                        notifyMe: .constant(true),
                        tattooLocation: .constant(.arms),
                        buttonAction: {}
    )
}
