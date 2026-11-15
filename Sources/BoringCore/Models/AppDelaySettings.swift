import Foundation

/// User preferences for the App Delays feature (Tab 2).
public struct AppDelaySettings: Codable, Equatable, Sendable {
    public enum Scope: String, Codable, CaseIterable, Sendable {
        /// No apps are delayed.
        case none
        /// Only the apps the user picked are delayed.
        case selectedApps
        /// Every app is delayed except the user's exclusions.
        case allExcept
    }

    /// How long the shield makes you wait before an app can be opened. Fixed, so not saved with the settings.
    public static let delaySeconds = 10

    public let scope: Scope
    /// How long an app stays usable after passing the shield.
    public let unlockMinutes: Int

    public static let `default` = AppDelaySettings(
        scope: .none,
        unlockMinutes: 15
    )

    public func with(
        scope: Scope? = nil,
        unlockMinutes: Int? = nil
    ) -> AppDelaySettings {
        AppDelaySettings(
            scope: scope ?? self.scope,
            unlockMinutes: unlockMinutes ?? self.unlockMinutes
        )
    }
}

extension AppDelaySettings {
    private enum CodingKeys: String, CodingKey {
        case scope, unlockMinutes
    }

    /// Tolerates settings saved in an older shape: keys that no longer exist are ignored
    /// (and dropped on the next save), and missing or unreadable keys take their default.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        func field<T: Decodable>(_ key: CodingKeys, or fallback: T) -> T {
            (try? container.decodeIfPresent(T.self, forKey: key)) ?? fallback
        }
        self.init(
            scope: field(.scope, or: Self.default.scope),
            unlockMinutes: field(.unlockMinutes, or: Self.default.unlockMinutes)
        )
    }
}

/// Whether the user has granted this app Screen Time (Family Controls) access.
public enum ScreenTimeAuthorization: Equatable, Sendable {
    case notDetermined, denied, approved
}
