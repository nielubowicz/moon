import Foundation
import SwiftUI

extension Network {
    enum NetworkError: Error {
        case clientError(Int)
        case serverError(Int)
        case unexpectedStatusCode(Int)
        case decodingError(DecodingError)
    }
}

extension Network {
    protocol NetworkProvider: ObservableObject {
        func getToday() async throws -> MoonModel?
        func getMoonModelForDate(_ date: Date) async throws -> MoonModel?
        func getDateRange(from: Date, to: Date) async throws -> [MoonModel]?
        func clearCache() async
    }
}

extension Network {
    actor NetworkManager: NSObject, NetworkProvider {
        let cache: NSCache<NSString, MoonCacheEntryObject>
        let dataLoader: DataLoadingProvider
        
        init(
            cache: NSCache<NSString, MoonCacheEntryObject> = .init(),
            dataLoader: DataLoadingProvider = DataLoader()
        ) {
            self.cache = cache
            self.dataLoader = dataLoader
        }
        
        func getToday() async throws -> MoonModel? {
            try await getMoonModelForDate(.now)
        }
        
        func getMoonModelForDate(_ date: Date) async throws -> MoonModel? {
            let date = Calendar.autoupdatingCurrent.startOfDay(for: date)
            if let cached = cache[date] {
                switch cached {
                case let .ready(value):
                    return value
                case let .loading(task):
                    return try? await task.value
                }
            }
            
            let task = Task<MoonModel, Error> {
                let response: MoonPhaseRangeResponse = try await dataLoader.loadData(from: Network.API.date(on: date))
                guard
                    let moonModel = response.moonPhases.map({ MoonModel(date: $0.key, phase: $0.value) }).first
                else {
                    throw NetworkError.decodingError(DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "No moon model found")))
                }
                return moonModel
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

        func getDateRange(from: Date, to: Date) async throws -> [MoonModel]? {
            let dates = Calendar.autoupdatingCurrent.enumerateDatesBetween(from, andEnd: to)
            
            let cachedModels: [MoonModel] = await dates
                .asyncCompactMap {
                    guard let cached = self.cache[$0] else { return nil }
                    switch cached {
                    case let .ready(value):
                        return value
                    case let .loading(task):
                        return try? await task.value
                    }
                }

            // All dates found in cache, return
            if cachedModels.count == dates.count {
                return cachedModels.sorted(by: <)
            }

            let task = Task<[MoonModel], Error> {
                let response: MoonPhaseRangeResponse = try await dataLoader.loadData(from: Network.API.dateRange(from: from, to: to))
                return response.moonPhases.map { MoonModel(date: $0.key, phase: $0.value) }
            }

            do {
                let viewModels = try await task.value
                viewModels.forEach { self.cache[$0.date] = .ready($0) }
                return viewModels.sorted(by: <)
            } catch {
                dates.forEach { self.cache[$0] = nil }
                throw error
            }
        }
        
        func clearCache() {
            cache.removeAllObjects()
        }
    }
}
