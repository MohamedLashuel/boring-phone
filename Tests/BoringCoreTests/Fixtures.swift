import Foundation
@testable import BoringCore

enum Fixtures {
    static func task(id: String) -> GuideTask {
        GuideTask(
            id: id,
            title: id,
            summary: "",
            symbol: "circle",
            slides: [],
            opensSettings: false
        )
    }
}
