import Foundation

/// A building block of an article section, decoded from `{ "type": ..., ... }` JSON objects.
public enum ArticleBlock: Hashable, Sendable {
    case paragraph(String)
    case bullets([String])
    case media(Media)
}

extension ArticleBlock: Codable {
    private enum CodingKeys: String, CodingKey {
        case type, text, items, media
    }

    private enum BlockType: String, Codable {
        case paragraph, bullets, media
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(BlockType.self, forKey: .type) {
        case .paragraph: self = .paragraph(try container.decode(String.self, forKey: .text))
        case .bullets: self = .bullets(try container.decode([String].self, forKey: .items))
        case .media: self = .media(try container.decode(Media.self, forKey: .media))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .paragraph(let text):
            try container.encode(BlockType.paragraph, forKey: .type)
            try container.encode(text, forKey: .text)
        case .bullets(let items):
            try container.encode(BlockType.bullets, forKey: .type)
            try container.encode(items, forKey: .items)
        case .media(let media):
            try container.encode(BlockType.media, forKey: .type)
            try container.encode(media, forKey: .media)
        }
    }
}

public struct ArticleSection: Codable, Hashable, Sendable {
    public let heading: String
    public let blocks: [ArticleBlock]
}

public struct Article: Codable, Identifiable, Hashable, Sendable {
    public let id: String
    public let title: String
    public let symbol: String
    public let summary: String
    public let sections: [ArticleSection]
}

public struct FeatureLibrary: Codable, Sendable {
    public let articles: [Article]
}
