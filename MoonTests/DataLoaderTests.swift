@testable import Moon
import XCTest

final class DataLoaderTests: XCTestCase {
    func testDataLoaderThrows404ErrorForFakeURL() async throws {
        let fakeURL = URL(string: "https://example.com/fake-endpoint")!
        let dataLoader = Network.DataLoader()
        
        do {
            _ = try await dataLoader.loadData(from: Network.API.arbitrary(url: fakeURL)) as MoonPhaseDay
            XCTFail("Expected a 404 error, but no error was thrown.")
        } catch let Network.NetworkError.clientError(statusCode) {
            XCTAssertEqual(404, statusCode, "Expected a 404 error, but got code: \(statusCode).")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
