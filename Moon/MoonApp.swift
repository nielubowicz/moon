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
    @ObservedObject private var locationManager = Network.LocationManager.shared
    
    var body: some Scene {
        WindowGroup {
            if locationManager.currentZipCode.isEmpty {
                ProgressView(label: { Text("Loading Location...") })
                    .progressViewStyle(.circular)
                    .padding(48)
                    .background(Color.black.opacity(0.4))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .task {
                        locationManager.beginUpdates()
                    }
            } else {
                ContentView()
                    .environment(\.networkProvider, Network.NetworkManager())
                    .modelContainer(for: MoonModel.self)
            }
        }
    }
}
