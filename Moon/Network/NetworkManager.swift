import Foundation

extension Network {
    enum NetworkError: Error {
        case urlError(URLError)
        case decodingError(DecodingError)
    }
}

extension Network {
    protocol NetworkProvider {
        func getToday() async throws -> MoonModel?
        func getDateRange(from: Date, to: Date) async throws -> [MoonModel]?
    }
}

extension Network {
    protocol DataLoadingProvider {
        func loadData<T: Decodable>(from requestType: Network.API) async throws -> T
    }
}

extension Network {
    actor DataLoader: DataLoadingProvider {
        func loadData<T: Decodable>(from requestType: Network.API) async throws -> T {
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
    actor NetworkManager: ObservableObject, NetworkProvider {
        let cache: NSCache<NSString, MoonCacheEntryObject>
        let dataLoader: DataLoadingProvider
        
        init(cache: NSCache<NSString, MoonCacheEntryObject> = .init(), dataLoader: DataLoadingProvider) {
            self.cache = cache
            self.dataLoader = dataLoader
        }
        
        func getToday() async throws -> MoonModel? {
            let date = Date.now
            if let cached = cache[date] {
                switch cached {
                case .ready(let value):
                    return value
                case .loading(let task):
                    return try? await task.value
                }
            }
            
            let task = Task<MoonModel, Error> {
                let response: MoonPhaseResponse = try await dataLoader.loadData(from: Network.API.today)
                return MoonModel(date: date, phase: response.moonPhase)
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
            let dateRange = from...to
            var dates = [Date]()
            Calendar
                .autoupdatingCurrent
                .enumerateDates(
                    startingAfter: from,
                    matching: DateComponents(hour: 0),
                    matchingPolicy: .nextTime,
                    direction: .forward) { result, exactMatch, stop in
                        guard let result = result, result < to else { stop = true; return }
                        dates.append(result)
                    }
            
            let cachedModels: [MoonModel] = await dates
                .asyncCompactMap {
                    guard let cached = self.cache[$0] else { return nil }
                    switch cached {
                    case .ready(let value):
                        return value
                    case .loading(let task):
                        return try? await task.value
                    }
                }
            
            
            // All dates found in cache, return
            if cachedModels.count == dates.count {
                return cachedModels
            }
                    
            let task = Task<[MoonModel], Error> {
                let response: MoonPhaseRangeResponse = try await dataLoader.loadData(from: Network.API.dateRange(from: from, to: to))
                return response.moonPhases.map { MoonModel(date: $0.key, phase: $0.value) }
            }
            
            do {
                let viewModels = try await task.value
                viewModels.forEach { self.cache[$0.date] = .ready($0) }
                return viewModels
            } catch {
                dates.forEach { self.cache[$0] = nil }
                throw error
            }
        }
    }
}

extension Network {
    actor PreviewNetworkManager: Observable, ObservableObject, NetworkProvider {
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

extension Sequence {
    func asyncMap<T>(_ transform: @escaping (Element) async -> T) async -> [T] {
        return await withTaskGroup(of: T.self) { group in
            var transformedElements = [T]()
            
            for element in self {
                group.addTask {
                    return await transform(element)
                }
            }
            
            for await transformedElement in group {
                transformedElements.append(transformedElement)
            }
            
            return transformedElements
        }
    }
    
    func asyncCompactMap<T>(_ transform: @escaping (Element) async -> T?) async -> [T] {
        return await withTaskGroup(of: T?.self) { group in
            var transformedElements = [T]()

            for element in self {
                group.addTask {
                    return await transform(element)
                }
            }

            for await transformedElement in group {
                guard let transformedElement = transformedElement else { continue }
                transformedElements.append(transformedElement)
            }

            return transformedElements
        }
    }
}
