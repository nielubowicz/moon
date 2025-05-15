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
    @ObservedObject private var locationManager = Location.LocationManager.shared
    @Environment(\.calendarManager) private var calendarManager
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.networkProvider, Network.NetworkManager())
                .modelContainer(for: MoonModel.self)
                .overlay {
                    if locationManager.currentZipCode.isEmpty {
                        ProgressView(label: { Text(L10n.loadingLocation) })
                            .progressViewStyle(.circular)
                            .padding(48)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .task {
                                locationManager.beginUpdates()
                            }
                    }
                }
                .task {
                    await calendarManager.createCalendar()
                }
        }
    }
}
