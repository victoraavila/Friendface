//
//  FriendfaceApp.swift
//  Friendface
//
//  Created by Víctor Ávila on 16/06/24.
//

import SwiftUI
import SwiftData

@main
struct FriendfaceApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(for: User.self)
    }
}
