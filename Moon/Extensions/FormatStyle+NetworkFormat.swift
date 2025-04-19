import Foundation

extension FormatStyle where Self == Date.VerbatimFormatStyle {
    static var networkFormat: Date.VerbatimFormatStyle {
        .verbatim("\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)", locale: .autoupdatingCurrent, timeZone: .autoupdatingCurrent, calendar: .autoupdatingCurrent)
    }
}
