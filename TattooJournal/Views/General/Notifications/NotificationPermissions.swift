//
//  NotificationPermissions.swift
//  TattooJournal
//
//  Created by Andy Lawler on 06/08/2023.
//

import SwiftUI

struct NotificationPermissions: View {

    @Binding var showNotificationPermissions: Bool

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "bell.badge")
                .resizable()
                .scaledToFit()
                .frame(width: 175, height: 175)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white)
            Text("Notifications")
                .font(.title).bold()
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
            Text("Press allow below to be presented with the option to approve notification permissions.")
                .font(.callout)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 25)
            Spacer()
                .frame(minHeight: 20, maxHeight: 50)
            Button {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("All set!")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
            } label: {
                Text("Allow")
                    .foregroundStyle(Color.accentColor)
                    .font(.callout).bold()
                    .padding(.vertical, 13)
                    .frame(width: 220)
                    .background(.white)
                    .clipShape(.buttonBorder)
            }
            Spacer()
        }
        .padding(.horizontal, -10)
        .background(
            LinearGradient(colors: [Color(.lighterAccent), Color.accentColor],
                           startPoint: .top,
                           endPoint: .bottom)
        )
        .overlay(Button {
            showNotificationPermissions = false
        } label: {
            XMarkButton()
        }, alignment: .topTrailing)
    }
}


#Preview {
    NotificationPermissions(showNotificationPermissions: .constant(true))
}
