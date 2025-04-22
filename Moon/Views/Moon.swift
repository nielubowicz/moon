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
                .fixedSize(horizontal: true, vertical: false)
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
        ForEach(MoonModel.terseCycle) { model in
            Moon(viewModel: model)
        }
    }
}

#Preview {
    VStack {
        HStack {
            ForEach(MoonModel.fullCycle[0...6]) { model in
                Moon(viewModel: model)
            }
        }
        HStack {
            ForEach(MoonModel.fullCycle[7...13]) { model in
                Moon(viewModel: model)
            }
        }
        HStack {
            ForEach(MoonModel.fullCycle[14...20]) { model in
                Moon(viewModel: model)
            }
        }
        
        HStack {
            ForEach(MoonModel.fullCycle[21...27]) { model in
                Moon(viewModel: model)
            }
        }
    }
    .padding()
    .fixedSize(horizontal: false, vertical: true)
}
