import SwiftUI

extension Network {
    actor PreviewNetworkManager: NSObject, NetworkProvider {
        func getToday() async -> MoonModel? {
            MoonModel(date: .now, phase: 0.5)
        }
        
        func getDateRange(from: Date, to: Date) async -> [MoonModel]? {
            [
                MoonModel(date: .now, phase: 0.5),
                MoonModel(date: .now, phase: 0.6),
                MoonModel(date: .now, phase: 0.7)
            ]
        }
    }
}
