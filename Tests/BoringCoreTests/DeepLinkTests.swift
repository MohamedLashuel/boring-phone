import Foundation
import Testing
@testable import BoringCore

struct DeepLinkTests {
    @Test(arguments: DeepLink.allCases)
    func roundTripsThroughURL(link: DeepLink) {
        #expect(DeepLink(url: link.url) == link)
    }

    @Test func rejectsOtherSchemesAndUnknownHosts() {
        #expect(DeepLink(url: URL(string: "https://clock-mode")!) == nil)
        #expect(DeepLink(url: URL(string: "boringphone://nope")!) == nil)
        #expect(DeepLink(url: URL(string: "boringphone:")!) == nil)
    }

    @Test func clockModeRunsTheShortcut() {
        #expect(DeepLink.clockMode.destination.absoluteString == "shortcuts://run-shortcut?name=Clock%20Mode")
    }
}
