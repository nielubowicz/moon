//
//  ContentView.swift
//  Moon
//
//  Created by mac on 9/23/24.
//
import SwiftUI

struct NetworkServiceKey: EnvironmentKey {
    static let defaultValue: any Network.NetworkProvider = Network.PreviewNetworkManager()
}


extension EnvironmentValues {
    var networkProvider: any Network.NetworkProvider {
        get { self[NetworkServiceKey.self] }
        set { self[NetworkServiceKey.self] = newValue }
    }
}


// TODO: Add location picking
// TODO: Remove saved data if location changes
// TODO: Add event system

import SwiftData

struct ContentView: View {
    @Environment(\.networkProvider) var networkManager

    @State var viewModel: MoonModel?
    @State var viewModels = [MoonModel]()
    @State var index = 0

    @State var showPicker = false
    @State var selectedDate: Date = .now
    @Query(sort: \MoonModel.date, order: .forward) var storedModels: [MoonModel]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        if isProduction {
            VStack {
                if viewModels.count > 0 {
                    AnimatedMoon(models: viewModels)
                        .transition(.slide)
                }
                Spacer()
                Button("Select Date") {
                    showPicker = true
                }
            }
            .padding()
            .overlay {
                if showPicker {
                    DatePicker("moon date", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .background(.black)
                        .frame(width: 320)
                        .padding()
                }
            }
            .onChange(of: Network.LocationManager.shared.currentZipCode) { _, _ in
                requestMoonModels()
            }
            .onChange(of: selectedDate) { _, _ in
                showPicker = false
                requestMoonModels()
            }

        }
    }

    private func requestMoonModels() {
        if let storedModel = storedModels.first(
            where: { $0.date == Calendar.autoupdatingCurrent.startOfDay(for: selectedDate) }
        ) {
            viewModels = [storedModel]
            return
        }
        
        Task {
            if let model = try? await networkManager.getDate(selectedDate) {
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

    private var isProduction: Bool {
        NSClassFromString("XCTestCase") == nil
    }
}

#Preview {
    ContentView()
        .environment(\.networkProvider, Network.PreviewNetworkManager())
}
