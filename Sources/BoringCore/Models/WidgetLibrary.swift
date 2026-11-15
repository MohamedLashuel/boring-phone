import Foundation

/// Where a widget can be placed.
public enum WidgetPlacement: String, Codable, CaseIterable, Sendable {
    case homeScreen
    case lockScreen
}

/// BoringPhone's own widgets, matching `WidgetItem.id` in widgets.json and each widget's `kind`.
public enum WidgetID: String, CaseIterable, Sendable {
    case reminder
    case clockMode = "clock-mode"
}

/// A slideshow explaining how to add widgets to one placement.
public struct WidgetGuide: Codable, Identifiable, Hashable, Sendable {
    public let placement: WidgetPlacement
    public let title: String
    public let slides: [Slide]

    public var id: WidgetPlacement { placement }
}

/// A widget the user can add, shown as a picture, a title and a description.
public struct WidgetItem: Codable, Identifiable, Hashable, Sendable {
    public let id: String
    public let title: String
    public let description: String
    public let media: Media
    public let placements: [WidgetPlacement]
    /// What BoringPhone's own widget shows. Nil for widgets made by other apps.
    public let widgetText: String?
}

/// Content for the Widgets tab.
public struct WidgetLibrary: Codable, Sendable {
    /// Explains the page, shown above everything else.
    public let intro: String
    public let guides: [WidgetGuide]
    public let widgets: [WidgetItem]

    public func widget(_ id: WidgetID) -> WidgetItem? {
        widgets.first { $0.id == id.rawValue }
    }
}
