import BoringCore
import UIKit

/// Sends incoming boringphone:// links (e.g. widget taps) where they lead.
enum DeepLinkRouter {
    @MainActor
    static func handle(_ url: URL) {
        DeepLink(url: url).map { UIApplication.shared.open($0.destination) }
    }
}
