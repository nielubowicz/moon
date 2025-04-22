//
//  MoonTests.swift
//  MoonTests
//
//  Created by mac on 9/23/24.
//

import XCTest
@testable import Moon

final class MoonPhaseResponseTests: XCTestCase {
    var data: Data = Data()
    override func setUpWithError() throws {
        let path = Bundle(for: type(of: self)).path(forResource: "TestJSON", ofType: "json") ?? ""
        let pathURL = URL(fileURLWithPath: path)
        self.data = try Data(contentsOf: pathURL)
    }
    
    func testPhases() {
        do {
            let response = try JSONDecoder().decode(MoonPhaseRangeResponse.self, from: data)
            XCTAssertNotNil(response)
//            XCTAssertEqual(response.moonPhases["2024-09-01"], 0.95)
//            XCTAssertEqual(response.moonPhases["2024-09-02"], 0)
//            XCTAssertNil(response.moonPhases["2024-09-03"])
        } catch {
            print(error)
        }
        
    }
}

final class DataLoaderTests: XCTestCase {
    func test404() {
        let dataLoader = Network.DataLoader()
        let fakeURL = URL(string: "h22p://this.is.not.a.real.url")!
        let data: MoonPhaseDay = dataLoader.loadData(from: Network.API.arbitrary(url: fakeURL))
        
    }
}
