import Foundation
import Testing
@testable import BoringCore

struct AppDelaySettingsTests {
    @Test func withChangesOnlyGivenFields() {
        let changed = AppDelaySettings.default.with(unlockMinutes: 30)
        #expect(changed.unlockMinutes == 30)
        #expect(changed.scope == AppDelaySettings.default.scope)
    }

    @Test func withNoArgumentsIsUnchanged() {
        #expect(AppDelaySettings.default.with() == .default)
    }
}
