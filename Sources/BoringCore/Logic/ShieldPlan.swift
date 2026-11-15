import Foundation

/// What should be shielded, derived purely from the delay scope and the user's selections.
/// Generic over token types so it doesn't depend on FamilyControls and can be tested anywhere.
public enum ShieldPlan<App: Hashable, Category: Hashable>: Equatable {
    case none
    case specific(apps: Set<App>, categories: Set<Category>)
    case allExcept(apps: Set<App>)

    public static func make(
        scope: AppDelaySettings.Scope,
        targetApps: Set<App>,
        targetCategories: Set<Category>,
        excludedApps: Set<App>
    ) -> ShieldPlan {
        switch scope {
        case .none: .none
        case .selectedApps: .specific(apps: targetApps, categories: targetCategories)
        case .allExcept: .allExcept(apps: excludedApps)
        }
    }
}
