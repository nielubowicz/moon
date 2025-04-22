import Foundation

struct MoonPhaseDay: Decodable {
    let moonPhase: Double
    let date: Date

    enum CodingKeys: String, CodingKey {
        case moonPhase = "moonphase"
        case date = "datetime"
    }
}
