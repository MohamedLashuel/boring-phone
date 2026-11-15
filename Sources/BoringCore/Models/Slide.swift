import Foundation

/// A visual that accompanies a slide or article section.
/// Until real assets exist, `description` explains what will go there.
public struct Media: Codable, Hashable, Sendable {
    public enum Kind: String, Codable, Sendable {
        case image
        case animation
    }

    public let kind: Kind
    public let description: String
}

/// One page of a slideshow (onboarding or a guide task walkthrough).
public struct Slide: Codable, Hashable, Sendable {
    public let title: String
    public let body: String
    public let media: Media?
}
