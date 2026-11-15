import BoringCore
import FamilyControls
import ManagedSettings

extension ScreenTimeClient {
    /// Talks to the real system. Needs the Family Controls entitlement.
    static let live = ScreenTimeClient(
        status: { authorization(from: AuthorizationCenter.shared.authorizationStatus) },
        requestAuthorization: {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            return authorization(from: AuthorizationCenter.shared.authorizationStatus)
        },
        apply: { ShieldService.apply($0, to: ManagedSettingsStore()) }
    )

    private static func authorization(from status: AuthorizationStatus) -> ScreenTimeAuthorization {
        switch status {
        case .approved: .approved
        case .denied: .denied
        default: .notDetermined
        }
    }
}
