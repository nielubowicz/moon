import SwiftUI

struct AnimatedMoon: View {
    let models: [MoonModel]
    let animationDuration: TimeInterval
    
    @State private var index = 0
    
    init(models: [MoonModel], animationDuration: TimeInterval = 1) {
        self.models = models
        self.animationDuration = animationDuration
    }
    
    var body: some View {
        VStack {
            if index < models.count {
                Moon(viewModel: models[index])
                    .animation(.linear, value: index)
            }
        }
        .onAppear {
            animateToNext()
        }
    }
    
    private func animateToNext() {
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            index = index < models.count - 1 ? index + 1 : 0
            animateToNext()
        }
    }
}

#Preview {
    AnimatedMoon(models: MoonModel.fullCycle, animationDuration: 0.2)
}
