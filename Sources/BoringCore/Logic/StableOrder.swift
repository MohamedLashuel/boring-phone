import Foundation

public enum StableOrder {
    /// Orders a set the same way every time, so lists built from it don't shuffle between updates or launches.
    /// Works for opaque values (like Screen Time tokens) by comparing their encoded form.
    public static func sorted<T: Encodable>(_ items: Set<T>) -> [T] {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        return items
            .map { (item: $0, key: (try? encoder.encode($0)) ?? Data()) }
            .sorted { $0.key.lexicographicallyPrecedes($1.key) }
            .map(\.item)
    }
}
