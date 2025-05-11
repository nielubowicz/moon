import EventKit
import SwiftUI

extension MoonCalendar {
    static let eventStore = EKEventStore()
    
    class CalendarManager {
        private static let title = "Moon Phases"
        
        @AppStorage("calendarIdentifier") private var identifier = "com.moon.moonphases"
        
        let store: EKEventStore
        var calendar: EKCalendar?
        
        init(store: EKEventStore = MoonCalendar.eventStore) {
            self.store = store
        }
        
        func createCalendar(title: String = CalendarManager.title) async {
            // Check for calendar by the saved identifier
            calendar = store.calendar(withIdentifier: identifier)
            guard calendar == nil else { return }
            
            // Check for the calendar by title, and save off the identifier if found.
            // The identifier may change during a full-sync.
            calendar = store.calendars(for: .event).first(where: {$0.title == CalendarManager.title})
            guard calendar == nil
            else {
                // Save the calendar's identifier in case our Moon Calendar was found with a new one
                identifier = calendar?.calendarIdentifier ?? ""
                return
            }
            
            do {
                let granted = try await store.requestFullAccessToEvents()
                
                guard
                    granted
                else {
                    print("Permission not granted, using default calendar.");
                    calendar = store.defaultCalendarForNewEvents
                    return
                }
                
                // Create a new calendar
                let calendar = EKCalendar(for: .event, eventStore: self.store)
                calendar.source = self.store.sources.first
                calendar.title = title
                calendar.cgColor = Color(red: 120 / 255.0, green: 6 / 255.0, blue: 6 / 255.0).cgColor
                
                do {
                    try self.store.saveCalendar(calendar, commit: true)
                    self.calendar = calendar
                    identifier = calendar.calendarIdentifier
                } catch {
                    print("Error saving calendar: \(error)")
                }
            } catch {
                print("Error requesting access to calendar: \(error)")
            }
        }
        
        func getEventsBetween(start: Date, and end: Date) -> [EKEvent] {
            guard
                let calendar = calendar
            else {
                print("Calendar not found; permissions were \(EKEventStore.authorizationStatus(for: .event) == .fullAccess ? "granted" : "denied") to view events")
                return []
            }
            let predicate = store.predicateForEvents(withStart: start, end: end, calendars: [calendar])
            return store.events(matching: predicate)
        }
    }
}
