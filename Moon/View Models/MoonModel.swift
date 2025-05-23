import Foundation
import SwiftData

@Model
final class MoonModel: Hashable, Identifiable {
    var id: UUID
    var date: Date
    var phase: Double
    var isHighlighted: Bool = false

    init(id: UUID = UUID(), date: Date, phase: Double, isHighlighted: Bool = false) {
        self.id = id
        self.date = date
        self.phase = phase
        self.isHighlighted = isHighlighted
    }
    
    var debugDescription: String {
        "MoonModel(\(id))[\(formattedDate)]: \(formattedPhase)"
    }
    
    var formattedPhase: String {
        let adjustedPhase = (phase <= 0.5 ? phase * 2 : 2 * (1 - phase))
        return adjustedPhase.formatted(.percent) + ", " + formattedPhaseDescription
    }
    
    var formattedPhaseDescription: String {
        if phase == 0 {
            L10n.Moon.Phase.new
        } else if phase < 0.25 {
            L10n.Moon.Phase.waxingCrescent
        } else if phase == 0.25 {
            L10n.Moon.Phase.firstQuarter
        } else if phase < 0.5 {
            L10n.Moon.Phase.waxingGibbous
        } else if phase == 0.5 {
            L10n.Moon.Phase.full
        } else if phase < 0.75 {
            L10n.Moon.Phase.waningGibbous
        } else if phase == 0.75 {
            L10n.Moon.Phase.thirdQuarter
        } else if phase < 1 {
            L10n.Moon.Phase.waningCrescent
        } else {
            L10n.Moon.Phase.new
        }
    }
    
    var formattedDate: String {
        date.formatted(date: .long, time: .omitted)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(formattedDate)
        hasher.combine(phase)
    }
}

extension MoonModel: Sendable {}

extension MoonModel: Equatable {
    static func == (lhs: MoonModel, rhs: MoonModel) -> Bool {
        lhs.date == rhs.date && lhs.phase == rhs.phase
    }
}

extension MoonModel: Comparable {
    static func < (lhs: MoonModel, rhs: MoonModel) -> Bool {
        lhs.date < rhs.date
    }
}

// MARK: Preview Data

extension MoonModel {
    static let fullCycle = [
        MoonModel(date: .now, phase: 0),
        MoonModel(date: .now, phase: 0.05),
        MoonModel(date: .now, phase: 0.08),
        MoonModel(date: .now, phase: 0.12),
        MoonModel(date: .now, phase: 0.18),
        MoonModel(date: .now, phase: 0.24),
        MoonModel(date: .now, phase: 0.25),
        MoonModel(date: .now, phase: 0.30),
        MoonModel(date: .now, phase: 0.33),
        MoonModel(date: .now, phase: 0.36),
        MoonModel(date: .now, phase: 0.39),
        MoonModel(date: .now, phase: 0.42),
        MoonModel(date: .now, phase: 0.45),
        MoonModel(date: .now, phase: 0.48),
        MoonModel(date: .now, phase: 0.51),
        MoonModel(date: .now, phase: 0.54),
        MoonModel(date: .now, phase: 0.57),
        MoonModel(date: .now, phase: 0.60),
        MoonModel(date: .now, phase: 0.63),
        MoonModel(date: .now, phase: 0.66),
        MoonModel(date: .now, phase: 0.69),
        MoonModel(date: .now, phase: 0.7),
        MoonModel(date: .now, phase: 0.75),
        MoonModel(date: .now, phase: 0.78),
        MoonModel(date: .now, phase: 0.82),
        MoonModel(date: .now, phase: 0.86),
        MoonModel(date: .now, phase: 0.90),
        MoonModel(date: .now, phase: 1),
    ]

    static let terseCycle = [
        MoonModel(date: .now, phase: 0),
        MoonModel(date: .now, phase: 0.25),
        MoonModel(date: .now, phase: 0.5),
        MoonModel(date: .now, phase: 0.75),
        MoonModel(date: .now, phase: 1),
    ]

    static func arbitrartCycle(phase: Double) -> MoonModel {
        MoonModel(date: .now, phase: phase)
    }
}
