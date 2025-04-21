import Foundation
import SwiftUI

struct Moon: View {
    let viewModel: MoonModel
    
    init(viewModel: MoonModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                moon
                shadow
            }
            
            Spacer()
            
            Text(viewModel.formattedDate)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .background(.black)
        .background(ignoresSafeAreaEdges: .all)
    }
    
    @ViewBuilder
    var moon: some View {
        Circle()
            .fill(.white)
            .frame(width: 100, height: 100)
    }
    
    @ViewBuilder
    var shadow: some View {
        MoonShadowView(viewModel: viewModel)
            .frame(width: 100, height: 100)
    }
}

#Preview {
    HStack {
        Moon(viewModel: MoonModel(date: .now, phase: 0))
        Moon(viewModel: MoonModel(date: .now, phase: 0.25))
        Moon(viewModel: MoonModel(date: .now, phase: 0.5))
        Moon(viewModel: MoonModel(date: .now, phase: 0.75))
        Moon(viewModel: MoonModel(date: .now, phase: 1))
    }
}

#Preview {
    VStack {
        HStack {
            Moon(viewModel: MoonModel(date: .now, phase: 0))
            Moon(viewModel: MoonModel(date: .now, phase: 0.05))
            Moon(viewModel: MoonModel(date: .now, phase: 0.08))
            Moon(viewModel: MoonModel(date: .now, phase: 0.12))
            Moon(viewModel: MoonModel(date: .now, phase: 0.18))
            Moon(viewModel: MoonModel(date: .now, phase: 0.24))
            Moon(viewModel: MoonModel(date: .now, phase: 0.25))
        }
        HStack {
            Moon(viewModel: MoonModel(date: .now, phase: 0.30))
            Moon(viewModel: MoonModel(date: .now, phase: 0.33))
            Moon(viewModel: MoonModel(date: .now, phase: 0.36))
            Moon(viewModel: MoonModel(date: .now, phase: 0.39))
            Moon(viewModel: MoonModel(date: .now, phase: 0.42))
            Moon(viewModel: MoonModel(date: .now, phase: 0.45))
            Moon(viewModel: MoonModel(date: .now, phase: 0.48))
        }
        HStack {
            Moon(viewModel: MoonModel(date: .now, phase: 0.51))
            Moon(viewModel: MoonModel(date: .now, phase: 0.54))
            Moon(viewModel: MoonModel(date: .now, phase: 0.57))
            Moon(viewModel: MoonModel(date: .now, phase: 0.60))
            Moon(viewModel: MoonModel(date: .now, phase: 0.63))
            Moon(viewModel: MoonModel(date: .now, phase: 0.66))
            Moon(viewModel: MoonModel(date: .now, phase: 0.69))
        }
        
        HStack {
            Moon(viewModel: MoonModel(date: .now, phase: 0.7))
            Moon(viewModel: MoonModel(date: .now, phase: 0.75))
            Moon(viewModel: MoonModel(date: .now, phase: 0.78))
            Moon(viewModel: MoonModel(date: .now, phase: 0.82))
            Moon(viewModel: MoonModel(date: .now, phase: 0.86))
            Moon(viewModel: MoonModel(date: .now, phase: 0.90))
            Moon(viewModel: MoonModel(date: .now, phase: 1))
        }
    }
}
