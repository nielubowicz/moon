//
//  MoonTests.swift
//  MoonTests
//
//  Created by mac on 9/23/24.
//

@testable import Moon
import XCTest

final class MoonPhaseResponseTests: XCTestCase {
    var data: Data = .init()
    override func setUpWithError() throws {
        let path = Bundle(for: type(of: self)).path(forResource: "TestJSON", ofType: "json") ?? ""
        let pathURL = URL(fileURLWithPath: path)
        data = try Data(contentsOf: pathURL)
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
    
    func testPhases() {
        do {
            let response = try Self.decoder.decode(MoonPhaseRangeResponse.self, from: data)
            XCTAssertNotNil(response)
            var testDate = Self.formatter.date(from: "2024-09-01")!
            XCTAssertEqual(response.moonPhases[testDate], 0.95)
            testDate = Self.formatter.date(from: "2024-09-02")!
            XCTAssertEqual(response.moonPhases[testDate], 0)
            testDate = Self.formatter.date(from: "2024-09-03")!
            XCTAssertNil(response.moonPhases[testDate])
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
