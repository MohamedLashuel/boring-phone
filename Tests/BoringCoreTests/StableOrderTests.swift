import Testing
@testable import BoringCore

struct StableOrderTests {
    @Test func sameSetAlwaysGivesSameOrder() {
        let items: Set = ["instagram", "maps", "games", "tiktok", "mail"]
        let rebuilt = Set(items.reversed())
        #expect(StableOrder.sorted(items) == StableOrder.sorted(rebuilt))
    }

    @Test func addingAnItemKeepsTheOthersInOrder() {
        let before = StableOrder.sorted(Set(["instagram", "maps", "games"]))
        let after = StableOrder.sorted(Set(["instagram", "maps", "games", "tiktok"]))
        #expect(after.filter(before.contains) == before)
    }

    @Test func keepsEveryItem() {
        #expect(Set(StableOrder.sorted(Set([3, 1, 2]))) == [1, 2, 3])
    }
}
