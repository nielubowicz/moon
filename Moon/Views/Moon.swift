import Foundation
import SwiftUI

struct Moon: View {
    let viewModel: MoonModel

    var body: some View {
        VStack {
            Spacer()

            ZStack {
                moon
                shadow
            }

            Spacer()

            Text(viewModel.formattedPhase)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .padding(.bottom)
            Text(viewModel.formattedDate)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .fixedSize(horizontal: true, vertical: false)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(.black)
        .background(ignoresSafeAreaEdges: .all)
    }

    @ViewBuilder
    var moon: some View {
        Circle()
            .fill(.white)
    }

    @ViewBuilder
    var shadow: some View {
        MoonShadowView(viewModel: viewModel)
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
            ForEach(MoonModel.fullCycle[0 ... 6]) { model in
                Moon(viewModel: model)
            }
        }
        HStack {
            ForEach(MoonModel.fullCycle[7 ... 13]) { model in
                Moon(viewModel: model)
            }
        }
        HStack {
            ForEach(MoonModel.fullCycle[14 ... 20]) { model in
                Moon(viewModel: model)
            }
        }

        HStack {
            ForEach(MoonModel.fullCycle[21 ... 27]) { model in
                Moon(viewModel: model)
            }
        }
    }
    .padding()
    .fixedSize(horizontal: false, vertical: true)
}
