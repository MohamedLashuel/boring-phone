import Foundation
import Testing
@testable import BoringCore

struct PersistenceTests {
    /// A fresh, isolated UserDefaults suite per test.
    let defaults: UserDefaults = {
        let name = "BoringCoreTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: name)!
        defaults.removePersistentDomain(forName: name)
        return defaults
    }()

    @Test func missingValueReturnsDefault() {
        #expect(StorageKeys.completedTaskIDs.read(from: defaults) == [])
        #expect(StorageKeys.hasCompletedOnboarding.read(from: defaults) == false)
        #expect(StorageKeys.appDelaySettings.read(from: defaults) == .default)
    }

    @Test func writtenValueReadsBack() {
        StorageKeys.completedTaskIDs.write(["grayscale", "wallpapers"], to: defaults)
        #expect(StorageKeys.completedTaskIDs.read(from: defaults) == ["grayscale", "wallpapers"])

        let settings = AppDelaySettings.default.with(scope: .allExcept, unlockMinutes: 45)
        StorageKeys.appDelaySettings.write(settings, to: defaults)
        #expect(StorageKeys.appDelaySettings.read(from: defaults) == settings)
    }

    @Test func corruptDataFallsBackToDefault() {
        defaults.set(Data("not json".utf8), forKey: StorageKeys.appDelaySettings.key)
        #expect(StorageKeys.appDelaySettings.read(from: defaults) == .default)
    }

    @Test func oldSettingsShapeKeepsWhatStillApplies() {
        // Saved by older versions: `isEnabled` and `delaySeconds` no longer exist, and `allApps` is no longer a scope.
        let old = #"{"isEnabled": true, "scope": "allApps", "delaySeconds": 20, "unlockMinutes": 30}"#
        defaults.set(Data(old.utf8), forKey: StorageKeys.appDelaySettings.key)
        let expected = AppDelaySettings.default.with(unlockMinutes: 30)
        #expect(StorageKeys.appDelaySettings.read(from: defaults) == expected)
    }

    @Test func missingSettingsKeysTakeTheirDefault() {
        defaults.set(Data(#"{"scope": "allExcept"}"#.utf8), forKey: StorageKeys.appDelaySettings.key)
        #expect(StorageKeys.appDelaySettings.read(from: defaults) == .default.with(scope: .allExcept))
    }

    @Test func savingDropsRemovedSettingsKeys() throws {
        let old = #"{"isEnabled": true, "scope": "selectedApps", "delaySeconds": 20}"#
        defaults.set(Data(old.utf8), forKey: StorageKeys.appDelaySettings.key)
        StorageKeys.appDelaySettings.write(StorageKeys.appDelaySettings.read(from: defaults), to: defaults)

        let saved = try #require(defaults.data(forKey: StorageKeys.appDelaySettings.key))
        let object = try #require(try JSONSerialization.jsonObject(with: saved) as? [String: Any])
        #expect(Set(object.keys) == ["scope", "unlockMinutes"])
    }

    @Test func keysAreDistinct() {
        let keys = [
            StorageKeys.hasCompletedOnboarding.key,
            StorageKeys.completedTaskIDs.key,
            StorageKeys.appDelaySettings.key,
        ]
        #expect(Set(keys).count == keys.count)
    }
}
