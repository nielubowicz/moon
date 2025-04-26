import Foundation

extension Network {
    actor PreviewDataLoader: DataLoadingProvider {
        func loadData<T: Decodable>(from requestType: Network.API) async throws -> T {
            let request = URLRequest(url: requestType.toURL("32601"))
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
