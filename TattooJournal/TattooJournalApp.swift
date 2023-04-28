//
//  TattooJournalApp.swift
//  TattooJournal
//
//  Created by Andy Lawler on 21/04/2023.
//

import SwiftUI

@main
struct TattooJournalApp: App {
    var appointments = Appointments()
    var userPreferences = UserPreferences()
    
    var body: some Scene {
        WindowGroup {
            TJTabView()
                .environmentObject(appointments)
                .environmentObject(userPreferences)
        }
    }
}

//@main
//struct TattooJournalApp: App {
//    let persistenceController = PersistenceController.shared
//
//    var body: some Scene {
//        WindowGroup {
//            CoreDataExample()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//        }
//    }
//}
