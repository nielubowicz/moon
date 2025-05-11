import SwiftUI

struct NetworkServiceKey: EnvironmentKey {
    static let defaultValue: any Network.NetworkProvider = Network.PreviewNetworkManager()
}

struct CalendarManagerKey: EnvironmentKey {
    static let defaultValue = MoonCalendar.CalendarManager()
}

extension EnvironmentValues {
    var networkProvider: any Network.NetworkProvider {
        get { self[NetworkServiceKey.self] }
        set { self[NetworkServiceKey.self] = newValue }
    }
    
    var calendarManager: MoonCalendar.CalendarManager {
        get { self[CalendarManagerKey.self] }
        set { self[CalendarManagerKey.self] = newValue }
    }
}
