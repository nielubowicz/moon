import Foundation

extension Network {
    protocol DataLoadingProvider {
        func loadData<T: Decodable>(from requestType: Network.API) async throws -> T
    }
}

import SwiftUI

extension Network {
    actor DataLoader: DataLoadingProvider {
//        let locationManager: LocationManager
//        
//        init(locationManager: LocationManager) {
//            self.locationManager = locationManager
//        }
//        
        func loadData<T: Decodable>(from requestType: Network.API) async throws -> T {
            let request = URLRequest(url: requestType.toURL(LocationManager.shared.currentZipCode))
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                if let httpResponse = response as? HTTPURLResponse {
                    // TODO: check for errors in response
                    if httpResponse.statusCode >= 400 {
                        throw NetworkError.urlError(URLError(URLError.Code(rawValue: httpResponse.statusCode)))
                    }
                }

                return try decode(data)
            } catch let error as URLError {
                throw NetworkError.urlError(error)
            } catch let error as DecodingError {
                throw NetworkError.decodingError(error)
            }
        }

        private static var formatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }

        private static var decoder: JSONDecoder {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(Self.formatter)
            return decoder
        }

        private func decode<T: Decodable>(_ data: Data) throws -> T {
            return try Self.decoder.decode(T.self, from: data)
        }
    }
}
