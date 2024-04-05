//
//  NextAppointmentView.swift
//  TattooJournal
//
//  Created by Andy Lawler on 17/11/2023.
//

import SwiftUI

struct NextAppointmentView: View {

    @Bindable var appointment: Appointment

    var body: some View {
        AppointmentCell(viewModel: .init(appointment: appointment, cellType: .upcoming))
            .padding(.horizontal)
    }
}

#Preview {
    NextAppointmentView(appointment: MockAppointments.mockAppointment)
}
