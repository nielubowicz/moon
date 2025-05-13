import SwiftUI

struct MoonShadow: Shape {
    var phase: Double

    var animatableData: Double {
        get { phase }
        set { phase = newValue }
    }

    enum Side {
        case left(phase: Double)
        case right(phase: Double)

        func width(_ inRect: CGRect) -> CGFloat {
            let base = inRect.size.width

            let factor = switch self {
            case .left: 1.0
            case .right: -1.0
            }

            // the left side of the curve stays "pinned" while the moon waxes (phase <= 0.5)
            // and the right side stays pinned while the moon wanes (phase > 0.5)
            switch self {
            case let .left(phase) where phase <= 0.5: return -base
            case let .right(phase) where phase > 0.5: return base
            default: break
            }

            // retrieve the phase
            let phase = switch self {
            case let .left(phase),
                 let .right(phase): phase
            }

            // deriving the scale and offset (base) from the rect size
            // means that we can use a generic equation: y = -4 * size * (x - 0.5) + size
            return -base * 4 * (phase - 0.5) + (base * factor)
        }
    }

    func path(in rect: CGRect) -> Path {
        // extend the top and bottom just past the boundaries
        let top = CGPointMake(rect.midX, rect.minY - 44)
        let bottom = CGPointMake(rect.midX, rect.maxY + 44)
        let rightControl = CGPointMake(rect.midX + Side.right(phase: phase).width(rect), rect.midY)
        let leftControl = CGPointMake(rect.midX + Side.left(phase: phase).width(rect), rect.midY)

        return Path { p in
            p.move(to: top)
            p.addQuadCurve(to: bottom, control: rightControl)
            p.addQuadCurve(to: top, control: leftControl)
        }
    }
}
