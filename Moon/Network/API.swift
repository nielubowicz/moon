import Foundation

extension Network {
    private static let apiKey = "PZ3PJAZ9AQZ8BSZUNYJ78PZSD"
    private static let baseURL = URL(string: "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline")!
    // TODO: Get user zipcode ? or default to one

    enum API {
        case date(on: Date)
        case dateRange(from: Date, to: Date)
        #if canImport(MoonTests)
            case arbitrary(url: URL)
        #endif
        
        func toURL(_ withZipCode: String) -> URL {
            var url = Network.baseURL
            url.append(components: withZipCode)
            
            switch self {
            case let .date(date):
                url.append(component: date.formatted(.networkFormat))
            case let .dateRange(fromDate, toDate):
                url.append(component: fromDate.formatted(.networkFormat))
                url.append(component: toDate.formatted(.networkFormat))
            #if canImport(MoonTests)
                case let .arbitrary(url): return url
            #endif
            }
            return url.appending(
                queryItems: [
                    URLQueryItem(name: "key", value: Network.apiKey),
                    URLQueryItem(name: "include", value: "days"),
                    URLQueryItem(name: "elements", value: "datetime,moonphase")
                ],
            )
        }
    }
}

extension Network.API: Hashable {
    func hash(into hasher: inout Hasher) {
        switch self {
        case let .date(date):
            hasher.combine(date)
        case let .dateRange(beginning, end):
            hasher.combine(beginning)
            hasher.combine(end)
        #if canImport(MoonTests)
            case let .arbitrary(url):
                hasher.combine(url)
        #endif
        }
    }
}
