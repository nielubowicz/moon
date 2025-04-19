import Foundation

struct MoonPhaseResponse: Codable {
    let moonPhase: Double
    
    public init(moonPhase: Double) {
        self.moonPhase = moonPhase
    }
    
    enum RootKeys: String, CodingKey {
        case currentConditions
    }
    
    enum CurrentConditionsKeys: String, CodingKey {
        case moonPhase = "moonphase"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        let currentConditions = try container.nestedContainer(keyedBy: CurrentConditionsKeys.self, forKey: .currentConditions)
        self.moonPhase = try currentConditions.decode(Double.self, forKey: .moonPhase)
    }
}
