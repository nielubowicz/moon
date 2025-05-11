import SwiftUI

struct MoonShadowView: View {
    let viewModel: MoonModel

    var body: some View {
        MoonShadow(phase: viewModel.phase)
            .clipShape(Circle())
            .foregroundStyle(viewModel.isHighlighted ? Color.red.opacity(0.3) : Color.black.opacity(0.3))
            .blur(radius: 4)
    }
}

#Preview {
    @Previewable
    @State var phase = 0.001

    VStack {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: 200, height: 200)
            MoonShadowView(viewModel: MoonModel(date: .now, phase: phase))
                .frame(width: 200, height: 200)
        }
        Spacer()
        Slider(value: $phase)
    }
    .background(Color.gray.opacity(0.2))
    .frame(width: 400, height: 400)
    .padding()
}
