import BoringCore
import FamilyControls
import Foundation
import ManagedSettings
import Observation

/// State for the App Delays tab: preferences, picked apps, and Screen Time authorization.
/// Every change is persisted and re-applied to the system shields.
@MainActor
@Observable
final class AppDelayStore {
    private(set) var settings: AppDelaySettings
    private(set) var targets: FamilyActivitySelection
    private(set) var exclusions: FamilyActivitySelection
    private(set) var authorization: ScreenTimeAuthorization
    private(set) var lastError: String?

    @ObservationIgnored private let client: ScreenTimeClient

    private static let targetsKey = Persisted<FamilyActivitySelection>(key: "appDelayTargets") { FamilyActivitySelection() }
    private static let exclusionsKey = Persisted<FamilyActivitySelection>(key: "appDelayExclusions") { FamilyActivitySelection() }

    init(client: ScreenTimeClient) {
        self.client = client
        settings = StorageKeys.appDelaySettings.read()
        targets = Self.targetsKey.read()
        exclusions = Self.exclusionsKey.read()
        authorization = client.status()
        StorageKeys.appDelaySettings.write(settings)
    }

    var targetApps: [ApplicationToken] { StableOrder.sorted(targets.applicationTokens) }
    var targetCategories: [ActivityCategoryToken] { StableOrder.sorted(targets.categoryTokens) }
    /// Only apps: an "all except" shield can't exempt whole categories.
    var excludedApps: [ApplicationToken] { StableOrder.sorted(exclusions.applicationTokens) }

    func requestAuthorization() async {
        do {
            authorization = try await client.requestAuthorization()
            lastError = nil
        } catch {
            authorization = client.status()
            lastError = error.localizedDescription
        }
        applyShields()
    }

    func update(_ transform: (AppDelaySettings) -> AppDelaySettings) {
        settings = transform(settings)
        StorageKeys.appDelaySettings.write(settings)
        applyShields()
    }

    func setTargets(_ selection: FamilyActivitySelection) {
        targets = selection
        Self.targetsKey.write(selection)
        applyShields()
    }

    func setExclusions(_ selection: FamilyActivitySelection) {
        exclusions = selection
        Self.exclusionsKey.write(selection)
        applyShields()
    }

    private func applyShields() {
        guard authorization == .approved else { return }
        client.apply(ShieldService.plan(settings: settings, targets: targets, exclusions: exclusions))
    }
}
