import Testing
@testable import BoringCore

/// Uses plain strings as stand-ins for FamilyControls' opaque app and category tokens.
struct ShieldPlanTests {
    typealias Plan = ShieldPlan<String, String>

    func plan(_ scope: AppDelaySettings.Scope) -> Plan {
        .make(
            scope: scope,
            targetApps: ["instagram"],
            targetCategories: ["games"],
            excludedApps: ["maps"]
        )
    }

    @Test func noneShieldsNothing() {
        #expect(plan(.none) == .none)
    }

    @Test func selectedAppsShieldsTargets() {
        #expect(plan(.selectedApps) == .specific(apps: ["instagram"], categories: ["games"]))
    }

    @Test func allExceptShieldsEverythingExceptExclusions() {
        #expect(plan(.allExcept) == .allExcept(apps: ["maps"]))
    }
}
