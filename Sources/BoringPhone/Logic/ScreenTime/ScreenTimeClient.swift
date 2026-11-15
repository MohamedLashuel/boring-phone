import BoringCore

/// The Screen Time operations App Delays needs, as swappable functions.
/// Each implementation lives in its own file (`LiveScreenTime.swift`, `FakeScreenTime.swift`);
/// the app picks one where it builds its stores, so nothing else knows which is in use.
struct ScreenTimeClient {
    /// The current authorization.
    let status: @MainActor () -> ScreenTimeAuthorization
    /// Asks for authorization and returns the resulting status.
    let requestAuthorization: @MainActor () async throws -> ScreenTimeAuthorization
    /// Applies a shield plan to the system.
    let apply: @MainActor (AppShieldPlan) -> Void
}
