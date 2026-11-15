import UIKit

enum SettingsLink {
    /// The Settings app's own URL scheme with no path, so it opens Settings itself
    /// rather than a specific page (deep paths are no longer honored by iOS).
    static let root = URL(string: "App-prefs:")!

    @MainActor
    static func open(_ url: URL = root) {
        UIApplication.shared.open(url)
    }
}
