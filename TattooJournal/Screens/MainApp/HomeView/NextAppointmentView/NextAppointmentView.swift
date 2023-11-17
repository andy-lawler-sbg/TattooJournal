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
        VStack(spacing: 15) {
            HStack {
                Text("Next Appointment")
                    .font(.body)
                    .bold()
                Spacer()
            }
            .padding(.horizontal, 6)
            .padding(.bottom, 4)
            AppointmentCell(viewModel: .init(appointment: appointment, cellType: .upcoming))
                .padding(.horizontal)
        }.padding(.horizontal, 5)
    }
}

#Preview {
    NextAppointmentView(appointment: MockAppointments.mockAppointment)
}
