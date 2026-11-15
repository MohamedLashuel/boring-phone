import BoringCore
import FamilyControls
import ManagedSettings

typealias AppShieldPlan = ShieldPlan<ApplicationToken, ActivityCategoryToken>

/// Applies a `ShieldPlan` to the system's managed settings.
enum ShieldService {
    static func plan(
        settings: AppDelaySettings,
        targets: FamilyActivitySelection,
        exclusions: FamilyActivitySelection
    ) -> AppShieldPlan {
        .make(
            scope: settings.scope,
            targetApps: targets.applicationTokens,
            targetCategories: targets.categoryTokens,
            excludedApps: exclusions.applicationTokens
        )
    }

    static func apply(_ plan: AppShieldPlan, to store: ManagedSettingsStore) {
        switch plan {
        case .none:
            store.shield.applications = nil
            store.shield.applicationCategories = nil
        case .specific(let apps, let categories):
            store.shield.applications = apps.isEmpty ? nil : apps
            store.shield.applicationCategories = categories.isEmpty ? nil : .specific(categories)
        case .allExcept(let apps):
            store.shield.applications = nil
            store.shield.applicationCategories = .all(except: apps)
        }
    }
}
