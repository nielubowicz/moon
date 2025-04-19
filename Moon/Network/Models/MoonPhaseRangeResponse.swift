import Foundation

struct MoonPhaseRangeResponse: Decodable {
    let moonPhases: [Date: Double]
    
    public init(moonPhases: [Date: Double]) {
        self.moonPhases = moonPhases
    }
    
    enum RootKeys: String, CodingKey {
        case days
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        let days = try container.decode([MoonPhaseDay].self, forKey: .days)
        moonPhases = Dictionary(uniqueKeysWithValues: days.map { ($0.date, $0.moonPhase) })
    }
}
