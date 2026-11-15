import Foundation
import Testing
@testable import BoringCore

struct TaskCompletionTests {
    let wallpapers = Fixtures.task(id: "wallpapers")

    @Test func taskFollowsMarkedDone() {
        #expect(!TaskCompletion.isComplete(wallpapers, markedDone: []))
        #expect(TaskCompletion.isComplete(wallpapers, markedDone: ["wallpapers"]))
    }

    @Test func togglingAddsAndRemoves() {
        #expect(TaskCompletion.toggling("a", in: [], to: true) == ["a"])
        #expect(TaskCompletion.toggling("a", in: ["a", "b"], to: false) == ["b"])
    }

    @Test func togglingIsIdempotent() {
        #expect(TaskCompletion.toggling("a", in: ["a"], to: true) == ["a"])
        #expect(TaskCompletion.toggling("a", in: [], to: false) == [])
    }
}
