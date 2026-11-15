import Foundation

public enum ContentError: Error, CustomStringConvertible {
    case missingFile(String)
    case invalidFile(String, underlying: Error)

    public var description: String {
        switch self {
        case .missingFile(let name): "Missing content file: \(name).json"
        case .invalidFile(let name, let error): "Could not read \(name).json: \(error)"
        }
    }
}

/// Loads app content from the bundled `Content` folder.
public enum ContentLoader {
    public static func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        try JSONDecoder().decode(type, from: data)
    }

    public static func load<T: Decodable>(_ type: T.Type, named name: String, in bundle: Bundle) -> Result<T, ContentError> {
        guard let url = bundle.url(forResource: name, withExtension: "json", subdirectory: "Content") else {
            return .failure(.missingFile(name))
        }
        return Result { try decode(type, from: Data(contentsOf: url)) }
            .mapError { ContentError.invalidFile(name, underlying: $0) }
    }

    /// Loads one content file bundled with BoringCore.
    public static func load<T: Decodable>(_ type: T.Type, named name: String) -> Result<T, ContentError> {
        load(type, named: name, in: .module)
    }

    /// Loads the content bundled with BoringCore.
    public static func loadAll() -> Result<AppContent, ContentError> {
        loadAll(from: .module)
    }

    public static func loadAll(from bundle: Bundle) -> Result<AppContent, ContentError> {
        Result { () throws(ContentError) in
            try AppContent(
                onboarding: load(Onboarding.self, named: "onboarding", in: bundle).get(),
                guide: load(Guide.self, named: "guide", in: bundle).get(),
                widgets: load(WidgetLibrary.self, named: "widgets", in: bundle).get(),
                features: load(FeatureLibrary.self, named: "features", in: bundle).get()
            )
        }
    }
}
