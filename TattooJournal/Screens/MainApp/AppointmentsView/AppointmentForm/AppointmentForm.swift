//
//  AppointmentForm.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI

struct AppointmentForm: View {

    @EnvironmentObject var userPreferences: UserPreferences
    @EnvironmentObject var appointments: Appointments

    @Binding var isShowingAppointmentForm: Bool
    @FocusState private var focusedTextField: FormTextField?

    @Bindable var viewModel: AppointmentFormViewModel

    enum FormTextField {
        case artist, date, price, design, location
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker("Date", selection: $viewModel.appointment.date)
                    TextField("Artist", text: $viewModel.appointment.artist)
                        .focused($focusedTextField, equals: .artist)
                        .onSubmit { focusedTextField = .price }
                        .submitLabel(.next)
                    TextField("Price", text: $viewModel.appointment.price)
                        .keyboardType(.numbersAndPunctuation)
                        .focused($focusedTextField, equals: .price)
                        .onSubmit { focusedTextField = .design }
                        .submitLabel(.next)
                    TextField("Design", text: $viewModel.appointment.design)
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

                Section {
                    Button {
                        viewModel.isShowingMapView = true
                    } label: {
                        if viewModel.appointment.shop.location == nil {
                            Text("Set Location")
                        } else if viewModel.appointment.shop.title != "" {
                            Text("Currently @ \(viewModel.appointment.shop.title)")
                        } else {
                            Text("Currently @ Tattoo Shop")
                        }
                    }
                } header: {
                    Text("Location")
                } footer: {
                    Text("Add the location of the tattoo shop and save it for future reference with a name.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Section {
                    Toggle("Notify Me", isOn: $viewModel.appointment.notifyMe)
                        .tint(userPreferences.appColor)
                } header: {
                    Text("Notifications")
                } footer: {
                    Text("Turn this on to receive reminder notifications before your appointment.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                Section {
                    Button {
                        if viewModel.editingAppointment {
                            appointments.edit(viewModel.appointment)
                        } else {
                            appointments.add(viewModel.appointment)
                        }
                        isShowingAppointmentForm = false
                    } label: {
                        Text("Save Changes")
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                    }
                    .onTapGesture(perform: Haptics.shared.successHaptic)
                    if viewModel.editingAppointment {
                        Button {
                            appointments.delete(viewModel.appointment)
                            isShowingAppointmentForm = false
                        } label: {
                            Text("🚨 Delete Appointment 🚨")
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.accentColor)
                        }
                        .onTapGesture(perform: Haptics.shared.successHaptic)
                    }
                }
            }
            .navigationTitle("🧾 Log Appointment")
            .background(Color(.background))
        }
        .overlay(Button {
            isShowingAppointmentForm = false
        } label: {
            XMarkButton()
        }, alignment: .topTrailing)
        .sheet(isPresented: $viewModel.isShowingMapView) {
            AppointmentMapView(formViewModel: viewModel, isShowingMapView: $viewModel.isShowingMapView)
        }
    }
}

#Preview {
    AppointmentForm(isShowingAppointmentForm: .constant(true),
                    viewModel: AppointmentFormViewModel(appointment: MockAppointmentData().appointment))
        .tint(UserPreferences().appColor)
        .modifier(PreviewEnvironmentObjects())
}
