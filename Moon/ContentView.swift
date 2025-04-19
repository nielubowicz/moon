//
//  ContentView.swift
//  Moon
//
//  Created by mac on 9/23/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var networkManager: Network.NetworkManager
    
    @State var viewModel: MoonViewModel?
    
    var body: some View {
        if isProduction {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
            }
            .padding()
            .onAppear() {
                Task {
                    viewModel = try? await networkManager.getToday()
                    print(viewModel)
                    
                    let groupedData = await networkManager.getDateRange(
                        from: Date.now,
                        to: Date.now.addingTimeInterval(86400)
                    )
                    print(groupedData)
                }
            }
            .overlay {
                if let viewModel {
                    Moon(viewModel: viewModel)
                }
            }
        }
    }
    
    private var isProduction: Bool {
        NSClassFromString("XCTestCase") == nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = Network.PreviewNetworkManager()
        ContentView()
            .environmentObject(manager)
    }
}
