import SwiftUI
import SwiftData
import EventKit

// TODO: Add location picking

// TODO: Remove saved data if location changes

struct ContentView: View {
    @Environment(\.networkProvider) var networkManager
    @Environment(\.calendarManager) var calendarManager

    // Display state vars
    @State private var lastViewModels = [MoonModel]()
    @State var viewModels = [MoonModel]() {
        willSet {
            lastViewModels = viewModels
        }
        didSet {
            for event in events {
                viewModels.forEach { $0.isHighlighted = (event.startDate == $0.date) }
            }
        }
    }
    
    // Date picker state vars
    @State var showPicker = false
    @State var selectedDate: Date = .now
    
    // Location state vars
    @State var showLocationPicker = false
    
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
                        .transaction(value: viewModels) { transaction in
                            if let lastPhase = lastViewModels.first?.phase,
                               let currentPhase = viewModels.first?.phase {
                                transaction.animation =
                                (lastPhase == 0 && currentPhase >= 0.95) ||
                                (currentPhase == 0 && lastPhase >= 0.95) ? nil : .easeInOut
                            }
                        }
                } else {
                    Color.black
                }
                Spacer()
                buttons
            }
            .padding(.horizontal, 48)
            .onAppear {
                updateEventsAndModels()
            }
            .onChange(of: Location.LocationManager.shared.currentZipCode) { old, new in
                if old != new, old.isEmpty == false {
                    clearModels()
                }
                updateEventsAndModels()
            }
            .onChange(of: selectedDate) { _, _ in
                updateEventsAndModels()
            }
            .sheet(
                isPresented: $showPicker,
                onDismiss: {
                    showPicker = false
                    updateEventsAndModels()
                }
            ) {
                DatePicker("moon date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .frame(width: 320)
                    .padding(48)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .sheet(
                isPresented: $showingEventScreen,
                onDismiss: {
                    showingEventScreen = false
                    updateEventsAndModels()
                }
            ) {
                EventViewController(
                    event: calendarManager.eventWithTitle("The Thing", on: selectedDate),
                    eventStore: calendarManager.store,
                    delegate: EventViewControllerDelegate(isShowingEventScreen: $showingEventScreen)
                )
            }
            .sheet(
                isPresented: $showLocationPicker,
                onDismiss: { showLocationPicker = false }
            ) {
                Location
                    .LocationPicker(
                        selectedLocation: Location.LocationManager.shared.$currentZipCode
                    )
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
    
    @ViewBuilder
    var buttons: some View {
        HStack {
            Button("Select Date") {
                showPicker.toggle()
            }
            Spacer()
            Button(Location.LocationManager.shared.currentZipCode) {
                showLocationPicker.toggle()
            }
        }
        .padding(.horizontal, 48)
        .padding(.vertical, 24)
    }
    
    private func clearModels() {
        do {
            viewModels = []
            lastViewModels = []
            try modelContext.delete(model: MoonModel.self)
            try modelContext.save()
        } catch {
            print("Error deleting models: \(error)")
        }
    }
    
    private func updateEventsAndModels() {
        events = calendarManager.getEventsBetween(start: selectedDate, and: selectedDate)
        requestMoonModels()
    }
    
    private func requestMoonModels() {
        if let storedModel = storedModels.first(
            where: { $0.date == Calendar.autoupdatingCurrent.startOfDay(for: selectedDate) }
        ) {
            viewModels = [storedModel]
            return
        }
        
        Task {
            if let model = try? await networkManager.getMoonModelForDate(selectedDate) {
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
