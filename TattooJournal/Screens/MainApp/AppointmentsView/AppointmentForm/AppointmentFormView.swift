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

    @EnvironmentObject var userPreferences: UserPreferences
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
                notificationSection
                actionButtonSections
            }
            .navigationTitle("\(type == .create ? "Log" : "Update") Appointment")
            .background(Color(.background))
        }
        .alert(alertType?.title ?? "Generic Error", isPresented: $showingAlert, actions: {
            Button {
                guard let alertType else { return }
                switch alertType {
                case .noPrice:
                    price = ""
                default:
                    break
                }
                dismissAlerts()
            } label: {
                Text("Ok")
            }.tint(userPreferences.appColor)
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

    private var keyDetailsSection: some View {
        Section {
            DatePicker("Date", selection: $date)
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
            Text("Key Details")
        } footer: {
            Text("This includes your date, artist, price, design & body part.")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }

    private var notificationSection: some View {
        Section {
            Toggle("Notify Me", isOn: $notifyMe)
                .tint(userPreferences.appColor)
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
                        buttonAction()
                        dismiss()
                    } catch {
                        if let error = error as? FormValidationError {
                            alertType = error
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
        if name.isEmpty {
            errorsToThrow.append(FormValidationError.noArtist)
        } else if design.isEmpty {
            errorsToThrow.append(FormValidationError.noDesign)
        }
        if let _ = Double(price) {} else {
            errorsToThrow.append(FormValidationError.noPrice)
        }
        if errorsToThrow.count > 1 {
            throw FormValidationError.multipleErrors
        } else {
            if let error = errorsToThrow.first {
                throw error
            }
        }
    }

    private func dismissAlerts() {
        alertType = nil
    }

    enum FormValidationError: Error {
        case noArtist
        case noPrice
        case noDesign
        case multipleErrors

        var title: String {
            switch self {
            case .noArtist:
                return "No Artist Entered"
            case .noPrice:
                return "No Valid Price Entered"
            case .noDesign:
                return "No Design Entered"
            case .multipleErrors:
                return "Multiple Errors"
            }
        }

        var description: String {
            switch self {
            case .noArtist:
                return "Please enter your artist."
            case .noPrice:
                return "Please enter a valid price."
            case .noDesign:
                return "Please enter your design details."
            case .multipleErrors:
                return "Please enter appointment details."
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
