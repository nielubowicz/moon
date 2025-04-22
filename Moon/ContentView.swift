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
                        .clipShape(RoundedRectangle(cornerRadius: 8))
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
            if let models = try? await networkManager.getDateRange(
                from: .now,
                to: selectedDate
            ) {
                viewModels = models
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
