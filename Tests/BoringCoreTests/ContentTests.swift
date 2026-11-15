import Foundation
import Testing
@testable import BoringCore

/// Validates the bundled JSON content, since it lives outside the code and isn't checked by the compiler.
struct ContentTests {
    let content: AppContent

    init() throws {
        content = try ContentLoader.loadAll().get()
    }

    var allTasks: [GuideTask] { content.guide.groups.flatMap(\.tasks) }

    @Test func noSlideshowIsEmpty() {
        let slideshows = [("onboarding", content.onboarding.slides)]
            + allTasks.map { ("task \($0.id)", $0.slides) }
            + content.widgets.guides.map { ("widget guide \($0.placement)", $0.slides) }
        let empty = slideshows.filter(\.1.isEmpty).map(\.0)
        #expect(empty.isEmpty, "Empty slideshows: \(empty)")
    }

    @Test func idsAreUnique() {
        let taskIDs = allTasks.map(\.id)
        let groupIDs = content.guide.groups.map(\.id)
        let articleIDs = content.features.articles.map(\.id)
        #expect(Set(taskIDs).count == taskIDs.count)
        #expect(Set(groupIDs).count == groupIDs.count)
        #expect(Set(articleIDs).count == articleIDs.count)
    }

    @Test func everyWidgetPlacementHasAGuide() {
        let guided = Set(content.widgets.guides.map(\.placement))
        let used = Set(content.widgets.widgets.flatMap(\.placements))
        #expect(used.isSubset(of: guided))
        #expect(content.widgets.widgets.allSatisfy { !$0.placements.isEmpty })
    }

    @Test func ownWidgetsHaveText() {
        // The widget extension looks these up by ID.
        let missing = WidgetID.allCases.filter { (content.widgets.widget($0)?.widgetText ?? "").isEmpty }
        #expect(missing.isEmpty, "Widgets without text: \(missing)")
    }

    @Test func widgetIDsAreUnique() {
        let ids = content.widgets.widgets.map(\.id)
        #expect(Set(ids).count == ids.count)
    }

    @Test func requirePasscodeComesAfterFaceID() throws {
        // Face ID forces "Require Passcode: Immediately", so it must be turned off first.
        let ids = allTasks.map(\.id)
        let faceID = try #require(ids.firstIndex(of: "wake-and-unlock"))
        let passcode = try #require(ids.firstIndex(of: "require-passcode"))
        #expect(faceID < passcode)
    }

    @Test func missingFileIsReported() {
        let result = ContentLoader.load(Guide.self, named: "does-not-exist", in: .module)
        guard case .failure(.missingFile("does-not-exist")) = result else {
            Issue.record("Expected missingFile, got \(result)")
            return
        }
    }

    @Test func wrongShapeIsReported() {
        // onboarding.json is valid JSON but not a Guide.
        let result = ContentLoader.load(Guide.self, named: "onboarding", in: .module)
        guard case .failure(.invalidFile("onboarding", _)) = result else {
            Issue.record("Expected invalidFile, got \(result)")
            return
        }
    }
}
