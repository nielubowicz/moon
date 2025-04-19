import Foundation

extension Network {
    private static let apiKey = "PZ3PJAZ9AQZ8BSZUNYJ78PZSD"
    private static let baseURL = URL(string: "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/32601")!
    
    enum API {
        case today
        case dateRange(from: Date, to: Date)
        
        func toURL() -> URL {
            var url = Network.baseURL
            switch self {
            case .today: {}()
            case .dateRange(let fromDate, let toDate):
                url.append(component: fromDate.formatted(.networkFormat))
                url.append(component: toDate.formatted(.networkFormat))
            }
            return url.appending(queryItems: [URLQueryItem(name: "key", value: Network.apiKey)])
        }
    }
}

extension Network.API: Hashable {
    func hash(into hasher: inout Hasher) {
        switch self {
        case .today:
            hasher.combine(UUID())
        case .dateRange(let beginning, let end):
            hasher.combine(beginning)
            hasher.combine(end)
        }
    }
}
