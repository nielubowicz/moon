import Foundation

extension Network {
    enum NetworkError: Error {
        
    }
}

extension Network {
    protocol NetworkProvider {
        func getToday() async throws -> MoonViewModel?
        func getDateRange(from: Date, to: Date) async -> MoonPhaseRangeResponse?
    }
}

extension Network {
    actor NetworkManager: ObservableObject, NetworkProvider {
        
        private let cache = NSCache<NSString, MoonCacheEntryObject>()
        
        func getToday() async throws -> MoonViewModel? {
            let date = Date.now
            if let cached = cache[date] {
                switch cached {
                case .ready(let value):
                    return value
                case .loading(let task):
                    return try? await task.value
                }
            }
            
            let task = Task<MoonViewModel, Error> {
                let response: MoonPhaseResponse = try await loadData(from: Network.API.today)
                return MoonViewModel(date: date, phase: response.moonPhase)
            }
            
            cache[date] = .loading(task)
            
            do {
                let viewModel = try await task.value
                cache[date] = .ready(viewModel)
                return viewModel
            } catch {
                cache[date] = nil
                throw error
            }
        }
        
        func getDateRange(from: Date, to: Date) async -> MoonPhaseRangeResponse? {
            do {
                return try await loadData(from: Network.API.dateRange(from: from, to: to))
            } catch {
                // TODO: handle error
            }
            
            return nil
        }
        
        private func loadData<T: Decodable>(from requestType: Network.API) async throws -> T {
            let request = URLRequest(url: requestType.toURL())
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                // TODO: check for errors in response
                return try decode(data)
            } catch {
                // TODO: Handle error internally
                print(error)
                throw error
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

extension Network {
    actor PreviewNetworkManager: Observable, ObservableObject, NetworkProvider {
        func getToday() async -> MoonViewModel? {
            MoonViewModel(date: .now, phase: 0.5)
        }
        
        func getDateRange(from: Date, to: Date) async -> MoonPhaseRangeResponse? {
            MoonPhaseRangeResponse(moonPhases: [.now: 0.5, .now: 0.6, .now: 0.7])
        }
    }
}
