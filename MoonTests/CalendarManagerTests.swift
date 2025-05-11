@testable import Moon
import XCTest
import EventKit

class CalendarManagerTests: XCTestCase {
    
    func testCalendarCreation() async {
        let testTitle = "Test Moon Phases"
        let testEventStore = EKEventStore()
        let calendarManager = MoonCalendar.CalendarManager(store: testEventStore)
        await calendarManager.createCalendar(title: testTitle)
        
        let calendar = calendarManager.calendar
        XCTAssertNotNil(calendar)
        XCTAssertEqual(calendar?.title, testTitle)
        
        if let calendar {
            do {
                try testEventStore.removeCalendar(calendar, commit: true)
            } catch {
                XCTFail("Failed to remove calendar: \(error)")
            }
        }
    }
    
}
