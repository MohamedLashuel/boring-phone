import Foundation

/// Everything the app displays that isn't UI chrome, loaded from bundled JSON.
public struct AppContent: Sendable {
    public let onboarding: Onboarding
    public let guide: Guide
    public let widgets: WidgetLibrary
    public let features: FeatureLibrary
}
