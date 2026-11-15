import BoringCore

extension ScreenTimeClient {
    /// Stands in until the Family Controls entitlement is available: grants access on request
    /// and ignores shield plans. Like the real system, it remembers access across launches.
    static let fake = ScreenTimeClient(
        status: { fakeApproval.read() ? .approved : .notDetermined },
        requestAuthorization: {
            fakeApproval.write(true)
            return .approved
        },
        apply: { _ in }
    )

    private static let fakeApproval = Persisted<Bool>(key: "fakeScreenTimeApproved") { false }
}
