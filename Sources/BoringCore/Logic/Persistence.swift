import Foundation

/// A typed, Codable value stored in UserDefaults under a fixed key.
public struct Persisted<Value: Codable>: Sendable {
    public let key: String
    public let defaultValue: @Sendable () -> Value

    public init(key: String, defaultValue: @escaping @Sendable () -> Value) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public func read(from defaults: UserDefaults = .standard) -> Value {
        defaults.data(forKey: key)
            .flatMap { try? JSONDecoder().decode(Value.self, from: $0) }
            ?? defaultValue()
    }

    public func write(_ value: Value, to defaults: UserDefaults = .standard) {
        (try? JSONEncoder().encode(value)).map { defaults.set($0, forKey: key) }
    }
}

public enum StorageKeys {
    public static let hasCompletedOnboarding = Persisted<Bool>(key: "hasCompletedOnboarding") { false }
    public static let completedTaskIDs = Persisted<Set<String>>(key: "completedTaskIDs") { [] }
    public static let appDelaySettings = Persisted<AppDelaySettings>(key: "appDelaySettings") { .default }
}
