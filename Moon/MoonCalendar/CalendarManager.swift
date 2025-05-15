import EventKit
import SwiftUI

extension MoonCalendar {
    static let eventStore = EKEventStore()
    
    class CalendarManager {
        private static let title = L10n.moonPhases
        
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
                    print(L10n.Error.Calendar.permissionNotGranted);
                    calendar = store.defaultCalendarForNewEvents
                    return
                }
                
                // Create a new calendar
                let calendar = EKCalendar(for: .event, eventStore: store)
                calendar.source = store.sources.first
                calendar.title = title
                calendar.cgColor = Color(red: 120 / 255.0, green: 6 / 255.0, blue: 6 / 255.0).cgColor
                
                do {
                    try store.saveCalendar(calendar, commit: true)
                    self.calendar = calendar
                    identifier = calendar.calendarIdentifier
                } catch {
                    self.calendar = store.defaultCalendarForNewEvents
                    print(L10n.Error.Calendar.save, error)
                }
            } catch {
                print(L10n.Error.Calendar.requestAccess, error)
            }
        }
        
        func getEventsBetween(start: Date, and end: Date) -> [EKEvent] {
            guard
                let calendar = calendar
            else {
                if EKEventStore.authorizationStatus(for: .event) == .fullAccess {
                    print(L10n.Error.Calendar.NotFound.granted)
                } else {
                    print(L10n.Error.Calendar.NotFound.notGranted)
                }
                return []
            }
            let predicate = store.predicateForEvents(withStart: start, end: end, calendars: [calendar])
            return store.events(matching: predicate)
        }
        
        func eventWithTitle(_ title: String, on selectedDate: Date, recurrance: Int = 29) -> EKEvent {
            let event = EKEvent(eventStore: store)
            event.title = title
            event.startDate = selectedDate
            event.endDate = selectedDate
            event.isAllDay = true
            event.calendar = calendar
            event.recurrenceRules = [
                EKRecurrenceRule(recurrenceWith: .daily, interval: recurrance, end: nil)
            ]
            
            return event
        }
    }
}
