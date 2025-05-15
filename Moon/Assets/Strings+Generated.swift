// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Localizable.strings
  ///   Moon
  /// 
  ///   Created by mac on 5/15/25.
  internal static let done = L10n.tr("Localizable", "Done", fallback: "Done")
  /// Enter Zipcode
  internal static let enterZipcode = L10n.tr("Localizable", "Enter Zipcode", fallback: "Enter Zipcode")
  /// Loading Location …
  internal static let loadingLocation = L10n.tr("Localizable", "Loading Location", fallback: "Loading Location …")
  /// Calendar Title
  internal static let moonPhases = L10n.tr("Localizable", "Moon Phases", fallback: "Moon Phases")
  /// Select Date
  internal static let selectDate = L10n.tr("Localizable", "Select Date", fallback: "Select Date")
  internal enum Error {
    internal enum Calendar {
      /// Calendar
      internal static let permissionNotGranted = L10n.tr("Localizable", "error.calendar.permissionNotGranted", fallback: "Permission not granted, using default calendar.")
      /// Error requesting access to calendar:  $@
      internal static let requestAccess = L10n.tr("Localizable", "error.calendar.requestAccess", fallback: "Error requesting access to calendar:  $@")
      /// Error saving calendar: $@
      internal static let save = L10n.tr("Localizable", "error.calendar.save", fallback: "Error saving calendar: $@")
      internal enum NotFound {
        /// Calendar not found; permissions were granted to view events
        internal static let granted = L10n.tr("Localizable", "error.calendar.notFound.granted", fallback: "Calendar not found; permissions were granted to view events")
        /// Calendar not found; permissions were not granted to view events
        internal static let notGranted = L10n.tr("Localizable", "error.calendar.notFound.notGranted", fallback: "Calendar not found; permissions were not granted to view events")
      }
    }
    internal enum CoreData {
      /// CoreData
      internal static let deletion = L10n.tr("Localizable", "error.coreData.deletion", fallback: "Error deleting models: $@")
    }
    internal enum Location {
      /// Location
      internal static let notEnabled = L10n.tr("Localizable", "error.location.notEnabled", fallback: "Location services not enabled")
      /// Unknown CLLocationManager authorization status: $@
      internal static let unknown = L10n.tr("Localizable", "error.location.unknown", fallback: "Unknown CLLocationManager authorization status: $@")
    }
  }
  internal enum Moon {
    internal enum Phase {
      /// Moon Phases
      internal static let firstQuarter = L10n.tr("Localizable", "moon.phase.firstQuarter", fallback: "First Quarter")
      /// Full Moon
      internal static let full = L10n.tr("Localizable", "moon.phase.full", fallback: "Full Moon")
      /// New Moon
      internal static let new = L10n.tr("Localizable", "moon.phase.new", fallback: "New Moon")
      /// Third Quarter
      internal static let thirdQuarter = L10n.tr("Localizable", "moon.phase.thirdQuarter", fallback: "Third Quarter")
      /// Waning Crescent
      internal static let waningCrescent = L10n.tr("Localizable", "moon.phase.waningCrescent", fallback: "Waning Crescent")
      /// Waning Gibbous
      internal static let waningGibbous = L10n.tr("Localizable", "moon.phase.waningGibbous", fallback: "Waning Gibbous")
      /// Waxing Crescent
      internal static let waxingCrescent = L10n.tr("Localizable", "moon.phase.waxingCrescent", fallback: "Waxing Crescent")
      /// Waxing Gibbous
      internal static let waxingGibbous = L10n.tr("Localizable", "moon.phase.waxingGibbous", fallback: "Waxing Gibbous")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
