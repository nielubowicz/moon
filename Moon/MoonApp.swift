//
//  MoonApp.swift
//  Moon
//
//  Created by mac on 9/23/24.
//

import SwiftUI
import SwiftData

@main
struct MoonApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.networkProvider, Network.NetworkManager())
                .modelContainer(for: MoonModel.self)
                .task {
                    Network.LocationManager.shared.beginUpdates()
                }
        }
    }
}
