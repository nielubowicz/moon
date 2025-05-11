import SwiftUI

extension Network {
    actor PreviewNetworkManager: NSObject, NetworkProvider {
        func getToday() async -> MoonModel? {
            MoonModel(date: .now, phase: 0.5)
        }

        func getMoonModelForDate(_ date: Date) async -> MoonModel? {
            MoonModel(date: date, phase: 0.5)
        }
        
        func getDateRange(from begin: Date, to end: Date) async -> [MoonModel]? {
            var phase: Double = 0
            return Calendar
                .autoupdatingCurrent
                .enumerateDatesBetween(begin, andEnd: end)
                .compactMap { date in
                    phase += 0.05
                    return MoonModel(date: date, phase: phase)
                }
        }
    }
}
