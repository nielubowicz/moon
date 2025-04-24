@testable import Moon
import XCTest

final class DataLoaderTests: XCTestCase {
    func test404() async {
        let dataLoader = Network.DataLoader()
        let fakeURL = URL(string: "https://this.is.not.a.real.url")!
        
        var thrownError: Error?
        do {
            let _ = try await dataLoader.loadData(from: Network.API.arbitrary(url: fakeURL)) as MoonPhaseDay
        } catch {
            thrownError = error
        }
        
        XCTAssertNotNil(thrownError)
        XCTAssert(thrownError is URLError)
        let urlError = thrownError as? URLError
        XCTAssert(urlError?.code == .badURL)
    }
}
