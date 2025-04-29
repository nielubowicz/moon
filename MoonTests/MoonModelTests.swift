@testable import Moon
import XCTest

class MoonModelTests: XCTestCase {
    func testPhases() {
        XCTAssertEqual(MoonModel(date: .now, phase: 0).formattedPhase, "0%, New Moon")
        XCTAssertEqual(MoonModel(date: .now, phase: 0.125).formattedPhase, "25%, Waxing Crescent")
        XCTAssertEqual(MoonModel(date: .now, phase: 0.25).formattedPhase, "50%, First Quarter")
        XCTAssertEqual(MoonModel(date: .now, phase: 0.49).formattedPhase, "98%, Waxing Gibbous")
        XCTAssertEqual(MoonModel(date: .now, phase: 0.5).formattedPhase, "100%, Full Moon")
        XCTAssertEqual(MoonModel(date: .now, phase: 0.51).formattedPhase, "98%, Waning Gibbous")
        XCTAssertEqual(MoonModel(date: .now, phase: 0.75).formattedPhase, "50%, Third Quarter")
        XCTAssertEqual(MoonModel(date: .now, phase: 0.875).formattedPhase, "25%, Waning Crescent")
        XCTAssertEqual(MoonModel(date: .now, phase: 1).formattedPhase, "0%, New Moon")
    }
    
    func testDates() {
        let date = Date(timeIntervalSince1970: 0)
        let model = MoonModel(date: date, phase: 0)
        XCTAssertEqual(model.formattedDate, "December 31, 1969")
    }
}
