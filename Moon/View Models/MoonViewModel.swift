import Foundation

struct MoonViewModel {
    let date: Date
    let phase: Double
    
    var formattedDate: String {
        date.formatted(date: .long, time: .omitted)
    }
}

