import SwiftUI
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

import CoreLocation

extension Network {
    class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
        private let manager = CLLocationManager()
        private let geocoder = CLGeocoder()
        
        @AppStorage("currentZipCode") private(set) var currentZipCode: String = "" {
            willSet {
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }
        }
        
        private static var _shared: LocationManager = LocationManager()
        static var shared: LocationManager {
            return _shared
        }
        
        private override init() {
            super.init()
        }
        
        func beginUpdates() {
            manager.delegate = self
            switch manager.authorizationStatus {
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse,
                    .authorizedAlways:
                manager.requestLocation()
            case .denied,
                    .restricted:
                print("Location services not enabled")
            default:
                print("Unknown CLLocationManager authorization status: \(manager.authorizationStatus)")
            }
        }
    
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            switch manager.authorizationStatus {
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse,
                    .authorizedAlways:
                manager.requestLocation()
            case .denied,
                    .restricted:
                print("Location services not enabled")
            default:
                print("Unknown CLLocationManager authorization status: \(manager.authorizationStatus)")
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            Task {
                guard let location = locations.last else { return }
                do {
                    let placemark = try await geocoder.reverseGeocodeLocation(location).last
                    self.currentZipCode = placemark?.postalCode ?? ""
                } catch {
                    print(error)
                }
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
            print(error)
        }
    }
}
