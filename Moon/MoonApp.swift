//
//  MoonApp.swift
//  Moon
//
//  Created by mac on 9/23/24.
//

import SwiftUI

@main
struct MoonApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(Network.NetworkManager())
        }
    }
}
