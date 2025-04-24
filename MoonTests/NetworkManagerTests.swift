@testable import Moon
import XCTest

final class NetworkManagerTests: XCTestCase {
    var cache = NSCache<NSString, MoonCacheEntryObject>()
    var dataLoader = Network.PreviewDataLoader()
    
    let testModel = MoonModel(date: .now, phase: 0.5)
    
    func testCacheReturnValue() async {
        cache[.now] = .ready(testModel)
        
        let manager = Network.NetworkManager(cache: cache, dataLoader: dataLoader)
        let model = try? await manager.getDate(.now)
        XCTAssertNotNil(model)
        XCTAssertEqual(model!, testModel)
    }
    
    func testCacheLoadingValue() async {
        cache[.now] = .loading(Task<MoonModel, Error> { return testModel })
        
        let manager = Network.NetworkManager(cache: cache, dataLoader: dataLoader)
        let model = try? await manager.getDate(.now)
        XCTAssertNotNil(model)
        XCTAssertEqual(model!, testModel)
    }
}
