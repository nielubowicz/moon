import SwiftUI
import SwiftData
import EventKit

// TODO: Add location picking

// TODO: Remove saved data if location changes

struct ContentView: View {
    @Environment(\.networkProvider) var networkManager
    @Environment(\.calendarManager) var calendarManager

    // Display state vars
    @State var viewModel: MoonModel?
    @State var viewModels = [MoonModel]() {
        didSet {
            for event in events {
                viewModels.forEach { $0.isHighlighted = (event.startDate == $0.date) }
            }
        }
    }
    
    // Date picker state vars
    @State var showPicker = false
    @State var selectedDate: Date = .now
    
    // Calendar event state vars
    @State var events = [EKEvent]()
    @State var showingEventScreen = false
    
    @Query(sort: \MoonModel.date, order: .forward) var storedModels: [MoonModel]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        if isProduction {
            VStack {
                if viewModels.count > 0 {
                    AnimatedMoon(models: viewModels)
                        .onTapGesture(count: 2) {
                            showingEventScreen.toggle()
                        }
                } else {
                    Color.black
                }
                Spacer()
                Button("Select Date") {
                    showPicker = true
                }
            }
            .padding(.horizontal, 48)
            .overlay {
                if showPicker {
                    DatePicker("moon date", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .frame(width: 320)
                        .padding(48)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .onAppear {
                updateEventsAndModels()
            }
            .onChange(of: Location.LocationManager.shared.currentZipCode) { _, _ in
                updateEventsAndModels()
            }
            .onChange(of: selectedDate) { _, _ in
                showPicker = false
                updateEventsAndModels()
            }
            .sheet(isPresented: $showingEventScreen) {
                EventViewController(
                    event: event,
                    eventStore: calendarManager.store,
                    delegate: EventViewControllerDelegate(isShowingEventScreen: $showingEventScreen)
                )
            }
            .onChange(of: showingEventScreen) { _, _ in
                guard showingEventScreen == false else { return }
                updateEventsAndModels()
            }
            .animation(.easeInOut, value: viewModels)
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if abs(value.translation.height) > 120 { // Detect vertical swipe
                            showingEventScreen.toggle()
                            return
                        } else if value.translation.width > 0 { // Detect left-to-right swipe
                            decrementSelectedDate()
                        } else if value.translation.width < 0 { // Detect right-to-left swipe
                            incrementSelectedDate()
                        }
                    }
            )
        }
    }
    
    private var event: EKEvent {
        let event = EKEvent(eventStore: calendarManager.store)
        event.title = "The Thing"
        event.startDate = selectedDate
        event.endDate = selectedDate
        event.isAllDay = true
        event.calendar = calendarManager.calendar
        event.recurrenceRules = [
            EKRecurrenceRule(recurrenceWith: .daily, interval: 29, end: nil)
        ]
        
        return event
    }

    private func updateEventsAndModels() {
        events = calendarManager.getEventsBetween(start: selectedDate, and: selectedDate)
        requestMoonModels()
    }
    
    private func requestMoonModels() {
        if let storedModel = storedModels.first(
            where: { $0.date == Calendar.autoupdatingCurrent.startOfDay(for: selectedDate) }
        ) {
            storedModel.isHighlighted = events.contains(where: {$0.startDate == storedModel.date})
            viewModels = [storedModel]
            return
        }
        
        Task {
            if let model = try? await networkManager.getMoonModelForDate(selectedDate) {
                model.isHighlighted = events.contains(where: {$0.startDate == model.date})
                viewModels = [model]
                modelContext.insert(model)
                do {
                    try modelContext.save()
                } catch {
                    print(error)
                }
                
            }
        }
    }

    private func incrementSelectedDate() {
        selectedDate = Calendar.autoupdatingCurrent.date(byAdding: .day, value: 1, to: selectedDate) ?? .now
    }
    
    private func decrementSelectedDate() {
        selectedDate = Calendar.autoupdatingCurrent.date(byAdding: .day, value: -1, to: selectedDate) ?? .now
    }
    
    private var isProduction: Bool {
        NSClassFromString("XCTestCase") == nil
    }
}

#Preview {
    ContentView()
        .environment(\.networkProvider, Network.PreviewNetworkManager())
}
