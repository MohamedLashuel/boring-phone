import Foundation

public struct GuideTask: Codable, Identifiable, Hashable, Sendable {
    public let id: String
    public let title: String
    public let summary: String
    public let symbol: String
    public let slides: [Slide]
    /// Whether the walkthrough offers a shortcut to the Settings app.
    public let opensSettings: Bool
}

public struct TaskGroup: Codable, Identifiable, Hashable, Sendable {
    public let id: String
    public let title: String
    public let tasks: [GuideTask]
}

public struct Guide: Codable, Sendable {
    public let groups: [TaskGroup]
}
