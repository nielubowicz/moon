import CoreLocation
import SwiftUI

extension Location {
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
            checkLocationManagerStatusAndRequestLocationOrAuthorization(manager)
        }
    
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            checkLocationManagerStatusAndRequestLocationOrAuthorization(manager)
        }
        
        private func checkLocationManagerStatusAndRequestLocationOrAuthorization(_ manager: CLLocationManager) {
            switch manager.authorizationStatus {
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse,
                    .authorizedAlways:
                manager.requestLocation()
            case .denied,
                    .restricted:
                print(L10n.Error.Location.notEnabled)
            default:
                print(L10n.Error.Location.unknown, manager.authorizationStatus)
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            Task { @MainActor in
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
