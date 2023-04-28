//
//  Appointment.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import Foundation

struct Appointment: Identifiable {
    let id = UUID()
    var artist = ""
    var date = Date()
    var price = ""
    var design = ""
    var notifyMe = false
    var shop: Shop = Shop(location: nil, title: "")
}

struct MockAppointmentData {
    var appointment: Appointment {
        var appointment = Appointment()
        appointment.artist = "John Crompton"
        appointment.date = Calendar.current.date(byAdding: .month, value: 3, to: Date())!
        appointment.design = "☠️ Skull"
        appointment.price = "250"
        appointment.notifyMe = true
        appointment.shop = Shop(location: Location(id: UUID(),
                                                                  name: "Test",
                                                                  description: "Test Description",
                                                                  latitude: 50.0,
                                                                  longitude: 10),
                                               title: "Heart of Ink")
        return appointment
    }

    var appointment2: Appointment {
        var appointment = Appointment()
        appointment.artist = "John Crompton"
        appointment.date = Calendar.current.date(byAdding: .month, value: 1, to: Date())!
        appointment.design = "🐍 Snake"
        appointment.price = "200"
        appointment.notifyMe = true
        appointment.shop = Shop(location: Location(id: UUID(),
                                                                  name: "Test",
                                                                  description: "Test Description",
                                                                  latitude: 50.0,
                                                                  longitude: 10),
                                               title: "Heart of Ink")
        return appointment
    }

    var appointment3: Appointment {
        var appointment = Appointment()
        appointment.artist = "John Crompton"
        appointment.date = Calendar.current.date(byAdding: .month, value: 6, to: Date())!
        appointment.design = "🦅 Eagle"
        appointment.price = "300"
        appointment.notifyMe = true
        appointment.shop = Shop(location: Location(id: UUID(),
                                                                  name: "Test",
                                                                  description: "Test Description",
                                                                  latitude: 50.0,
                                                                  longitude: 10),
                                               title: "Heart of Ink")
        return appointment
    }

    var appointment4: Appointment {
        var appointment = Appointment()
        appointment.artist = "John Crompton"
        appointment.date = Calendar.current.date(byAdding: .month, value: 9, to: Date())!
        appointment.design = "⚓️ Ship"
        appointment.price = "200"
        appointment.notifyMe = true
        appointment.shop = Shop(location: Location(id: UUID(),
                                                                  name: "Test",
                                                                  description: "Test Description",
                                                                  latitude: 50.0,
                                                                  longitude: 10),
                                               title: "Heart of Ink")
        return appointment
    }

    var appointment5: Appointment {
        var appointment = Appointment()
        appointment.artist = "John Crompton"
        appointment.date = Calendar.current.date(byAdding: .month, value: -2, to: Date())!
        appointment.design = "🐆 Panther"
        appointment.price = "250"
        appointment.notifyMe = true
        appointment.shop = Shop(location: Location(id: UUID(),
                                                                  name: "Test",
                                                                  description: "Test Description",
                                                                  latitude: 50.0,
                                                                  longitude: 10),
                                               title: "Heart of Ink")
        return appointment
    }

    var appointment6: Appointment {
        var appointment = Appointment()
        appointment.artist = "John Crompton"
        appointment.date = Calendar.current.date(byAdding: .month, value: -10, to: Date())!
        appointment.design = "💀 Reaper"
        appointment.price = "150"
        appointment.notifyMe = true
        appointment.shop = Shop(location: Location(id: UUID(),
                                                                  name: "Test",
                                                                  description: "Test Description",
                                                                  latitude: 50.0,
                                                                  longitude: 10),
                                               title: "Heart of Ink")
        return appointment
    }
}
