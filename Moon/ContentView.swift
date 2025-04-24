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


// TODO: Add core data to persist Moon Data between sessions
// TODO: Add location picking
// TODO: Remove saved data if location changes
// TODO: Add event system
struct ContentView: View {
    @Environment(\.networkProvider) var networkManager

    @State var viewModel: MoonModel?
    @State var viewModels = [MoonModel]()
    @State var index = 0

    @State var showPicker = false
    @State var selectedDate: Date = .now

    var body: some View {
        if isProduction {
            VStack {
                if viewModels.count > 0 {
                    AnimatedMoon(models: viewModels)
                }
                Spacer()
                Button("Select Date") {
                    showPicker = true
                }
            }
            .padding()
            .onAppear {
                requestMoonModels()
            }
            .overlay {
                if showPicker {
                    DatePicker("moon date", selection: $selectedDate)
                        .datePickerStyle(.graphical)
                        .background(.white)
                }
            }
            .onChange(of: selectedDate) { _, _ in
                showPicker = false
                requestMoonModels()
            }
        }
    }

    private func requestMoonModels() {
        Task {
            if let model = try? await networkManager.getDate(selectedDate) {
                viewModels = [model]
                print(viewModels)
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
