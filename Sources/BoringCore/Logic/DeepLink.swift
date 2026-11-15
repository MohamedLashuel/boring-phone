import Foundation

/// Links into BoringPhone, e.g. from a widget tap, and where each one leads.
public enum DeepLink: String, CaseIterable, Sendable {
    /// Runs the Clock Mode shortcut, which opens Clock and starts Guided Access.
    case clockMode = "clock-mode"

    public static let scheme = "boringphone"
    public static let clockModeShortcutName = "Clock Mode"

    public init?(url: URL) {
        guard url.scheme == Self.scheme, let link = url.host.flatMap(Self.init(rawValue:)) else { return nil }
        self = link
    }

    /// The URL that opens this link in BoringPhone.
    public var url: URL {
        URL(string: "\(Self.scheme)://\(rawValue)")!
    }

    /// Where BoringPhone sends the user after receiving this link.
    public var destination: URL {
        switch self {
        case .clockMode: Self.shortcutURL(named: Self.clockModeShortcutName)
        }
    }

    static func shortcutURL(named name: String) -> URL {
        var components = URLComponents(string: "shortcuts://run-shortcut")!
        components.queryItems = [URLQueryItem(name: "name", value: name)]
        return components.url!
    }
}
