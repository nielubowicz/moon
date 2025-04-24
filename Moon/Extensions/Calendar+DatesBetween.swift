import Foundation

extension Calendar {
    func enumerateDatesBetween(_ start: Date, andEnd end: Date) -> [Date] {
        var dates = [Date]()
        Calendar
            .autoupdatingCurrent
            .enumerateDates(
                startingAfter: start,
                matching: DateComponents(hour: 0),
                matchingPolicy: .nextTime,
                direction: .forward
            ) { result, _, stop in
                guard let result = result, result < end else { stop = true; return }
                dates.append(result)
            }
        return dates
    }
}
