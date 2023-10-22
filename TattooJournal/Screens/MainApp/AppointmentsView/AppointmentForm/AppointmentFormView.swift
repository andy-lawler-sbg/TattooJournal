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
    
    var type: AppointmentFormType
    @Binding var date: Date
    @Binding var name: String
    @Binding var price: String
    @Binding var design: String
    @Binding var notifyMe: Bool

    var buttonAction: (() -> Void)

    @FocusState private var focusedTextField: FormTextField?
    enum FormTextField {
        case artist, date, price, design
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
        } header: {
            Text("Key Details")
        } footer: {
            Text("This includes your date, artist, price and design.")
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
                withAnimation {
                    buttonAction()
                    dismiss()
                }
            } label: {
                Text(type == .create ? "Create" : "Update")
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
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
                        buttonAction: {}
    )
}
